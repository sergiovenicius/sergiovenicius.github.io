---
title: "Audit the prices of cloud provider’s services"
date: 2022-11-28 00:00:00 -0300
categories: [Process]
tags: [Process]
---

A learning I had while working in my first technology startup was about scaling. In 9 months, the accounts grew around 1000 customer accounts.

We had to deal with some points:

– firefighting (with bugs and improving applications to handle the volume)
– fixing lots of bugs
– identify and scale servers to support all accounts

During this process, we raised the EC2 servers (most manually, on demand), including new technologies to handle caching (elasticache), databases (we divided RDS databases by customers). But our technology was outdated: we got lost while keeping it all updated (lots of microservices and hard to upgrade .net framework versions). Our monolith was the hardest one, and it used .net framework 4.6, which implied using Windows EC2 Servers, which costs a lot in AWS, and we also could not use the latest EC2 servers because they didn’t support some old technologies.

So, with this overview, when some big accounts left, we had hard times to scale down, and the costs didn’t follow those accounts leaving. This led us to hard times, once we had to deal with lots of bug fixes, but at the same time accepting new developments and features (to try balancing finances), and never really focusing on lowering the costs by paying attention to infrastructure, upgrading technologies, and focusing on cutting costs. With a small team of developers, either we develop those new features or we stop everything and focus on fixing the big elephant in the room.

My learnings here are:

– A company must have someone exclusively looking at cloud/infrastructure billing, focusing on cutting costs;
– A company must pay attention and handle software upgrades. In the long term, it will allow you to have less costs, to use brand new technologies (best servers, faster applications);
– A company must focus on both (infrastructure and upgrades) while using people to bring ideas to reduce costs, tips and looking to these new versions, models, libraries.

Looking at these points, lots of money will not be thrown away, and things won’t be too late to handle. People will be happy to deal with new technologies (and not sad while only fixing bugs) and it will also help them to feel better because they are evolving with the world, they won’t feel outdated.
