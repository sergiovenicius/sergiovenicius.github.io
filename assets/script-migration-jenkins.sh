## script to migrate: get job and post job using REST API in Jenkins

output="https://USER:PWD@http://NEW_JENKINS_URL/"
input="https://USER:PWD@https://OLD_JENKINS_URL/"

jobsTree=$(http $input/api/json?tree=jobs[name]|jq -r ".jobs[].name" |grep $1)

IFS=$'\n'
for job in $jobsTree ; do 
    echo "Get '$job' config.xml"
    https "$input/job/$job/config.xml" > /tmp/jenkins-job.xml
    https POST "$output/createItem?name=$job" Content-Type:"application/xml" < /tmp/jenkins-job.xml
done

rm /tmp/jenkins-job.xml

#########