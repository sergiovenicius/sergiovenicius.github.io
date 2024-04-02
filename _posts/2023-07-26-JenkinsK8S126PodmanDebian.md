---
title: "Jenkins + Kubernetes 1.26 + Podman + Debian 11 Bullseye"
date: 2023-07-26 00:00:00 -0300
categories: [Dev]
tags: [Dev]
---

These days ago, I had to upgrade a EKS (kubernetes) cluster from 1.23 to 1.26 in a project.

Upgrade versions 1 by 1, upgrade components, restart nodes (or auto scaling instances), ok.

When I first checked the dependencies, it seemed there should be no trouble. Hmmmm, my mistake.

I could miss that elephant in the room called: “we’re going to discontinue dockershim from k8s 1.24”.

Well, that wasn’t the worst problem at the end. As we didn’t use any microservice depending on that to run, we faced issues only when building updates in our microservices, which is done by using Jenkins.

The issue happened because we were using Jenkins inside kubernetes along with “docker in docker” model. That is a model where for each build you run into Jenkins, it raises another container specifically for that build.

Our issue was that a thid-party company installed and configured Jenkins while upgrading kubernetes last time, and they configured the image used in those pods raised by Jenkins as an image in their own repository, which we don’t have access to customize. As we finished the contract after the project was delivered, we ended up with this dependency. In that image was configured awscli2, docker, kubectl and some other tools needed to build images.

I spent some time until I was done with all the possible fixes I could imagine keeping the same structure we had.

My idea was to install podman for the docker commands that were being used.

So, some options I tried were:

using sidecars with postman installed along with the “private” image. But it didn’t work.
try installing podman through scripts in the jenkinsfile used to generate the builds. But it didn’t work as it couldn’t accept installing it because of permissions.
try changing the socket configuration from /var/run/docker.sock to /var/run/containerd.sock, but it seemed that there was something hard-coded because the builds were always trying to connect to unix://var/run/docker.sock.
maybe I tried some other things, but I didn’t take notes.
After those tries, I ended up thinking in a different perspective and re-deploy Jenkins in a single EC2 instance instead of inside kubernetes. A machine where I have full permission to install podman, kubectl, awscli2 and any library needed to run the builds. For that, I chose a Bitnami image with Jenkins. That was also a Debian 11 (Bullseye) OS, instead of the CentOS used in the old Jenkins.

With that said, here are some tutorials I used while configuring the tools: (I used “sudo su” before installing all tools below)

AWS CLI 2: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

also configuring the profile and permissions in AWS (I didn’t need to configure permissions, used a user I already had) (/ “aws configure”)

Kubectl: https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html

as I had already migrated to kubernetes 1.26, I had to install kubectl 1.26. Just followed the steps in the tutorial.

Podman: https://linux.how2shout.com/how-to-install-podman-in-debian-12-or-11-linux/

just followed the steps in the tutorial. Tested using podman images and podman ps

Once I had that configured, I tried running jenkins and it was ok. Remember that the EC2 machine must have the security group with port 80 and 443 opened to accept requests from the Internet.

After that, I was able to try to build a job and generate the image and have success. Long and winding road.

I created and configured a new Job in this new Jenkins, a “test job”, with the same configurations as in the old Jenkins.

Ok, that was easy: repositories, credentials, folders, paths, ok.

Then it came the jenkinsfile rewriting manual process to stop using new containers and replacing docker and aws commands.

Change the jenkinsfile to keep the environment variables inside it (instead of another yaml file as before), remove the “container(‘agentpod’)” statement inside the jenkins steps, reorder some commands we had before, like calling kubectl before aws sts get-caller-identity and aws login, and of course replace the “docker” commands by “podman” (yes, just this word).

In podman, all commands are the same as in docker: podman build, podman push, podman login aws, podman tag…

Below I put examples of the old and new jenkinsfiles (in the new Jenkinsfile I put some “debug” commands).

Old way: [Pipeline](assets/old-pipeline.yaml)

New way: [Pipeline](assets/new-pipeline.yaml)


Finally! It built and it was successful.

Last checkpoint: I had to migrate all the jobs that we had in the old jenkins to this new one.

Attention point: At some point I chose to use the same Jenkins version that was in the old Jenkins. It was 2.346.3.

After some research about it, where I found a script using java jar file (but it didn’t work as it ran but was never importing to the new Jenkins), found an extension called Job Import Plugin, I ended up finding a script in stackoverflow (https://stackoverflow.com/a/75951838), using Jenkins REST API:

[Script](assets/script-migration-jenkins.sh)

Took some time because it was 160 Jobs, but they were all ok.

All done, the hard work that remained was to migrate the Jenkinsfiles of all projects to use the new structure. The idea is that as the project needs a change and a new build, the developer does that fix in the jenkinsfile.

… Extension (migrating and building a project that uses port 80 and PHP)

During the jenkinsfile projects migration we found out that an application we had should be exposed at a lower port, or port 80. It was a PHP application.

While it builds, it needs the apache to listen in port 80, as a different application under Debian OS, otherwise it throws a conflict in the building.

In my case, I preferred to change Jenkins to listen in port 81 and let the application build/run in port 80.

But, to enable that behaviour, we needed to do some changes in the Bitnami image to run Apache2 in port 81, and the other main change was to enable Podman to use ports under 1024, which comes blocked by default when we install it.

The first tutorial that I used is to reconfigure the port for Jenkins to run in the Bitnami image I used.

The tutorial is this one: https://docs.bitnami.com/virtual-machine/apps/jenkins/administration/configure-port/

Once that is done, I had to enable “low ports” for podman, as it is guided by this tutorial below. This is needed by all builds that needs to use ports below 1024 (in my case most projects use ports higher than that).

https://rootlesscontaine.rs/getting-started/common/sysctl/

Extra: One thing we also identified while building the PHP application under Debian 11 Bullseye was that the PHP package is a kind of specific for Debian, like a copy. That existing, it seems that some extensions don’t work with it.

In the Dockerfile/Containerfile, we had an extension that should be installed for the application, and we were always receiving the error “E: Package ‘name of the package’ has no installation candidate”. In this case it was the package php-apcu (error E: Package ‘php-apcu’ has no installation candidate).

That lead me to this thread below:

https://github.com/docker-library/php/pull/542

In this case, we tried replacing the package we were using by another one.
