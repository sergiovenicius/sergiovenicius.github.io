---
title: "Some ways to handle technical debts"
date: 2024-04-04 00:00:00 -0300
categories: [Dev]
tags: [Dev]
---

Imagine a list of technical debts below:
- bug-fix
- missing validations in a feature
- database upgrade
- non-existent unit tests
- 2k line method in your code
- a class having multi responsibilities
- a feature developed with “shortcuts” (a.k.a. good technical debt).
Some of these tasks are immediate needs, but for product managers, might not align with the scheduled work in their roadmap.
Considering technical debt, such as a database upgrade, requires assessing its business value and potential return using the same criteria applied to other features.
From a product manager's viewpoint, prioritizing technical needs over roadmap tasks may seem to question the engineering team's focus.
So, how could we approach the resolution of technical debts? How could we balance new features and technical debts during the software development process?

Attacking Technical Debts

After reading some articles (https://www.infoq.com/news/2023/12/repaying-good-technical-debt/, https://verraes.net/2020/01/wall-of-technical-debt/, https://www.infoq.com/news/2024/03/tech-debt-software/), one of the best ways to deal with it is to be disciplined to handle it.
Discipline is key to preventing accumulating technical debt. And in order to be disciplined you should make it difficult to ignore the debt. It is to make it visible. A good approach is to use a technical debt wall, which brings visibility. In the long term, high visibility results in frequent conversations about the tech debt inventory and what you are doing about it as a software organization.
Not having any technical debt means liquidity, and liquidity means optionality. When you have optionality, you are available to deliver more value to the business. The problem isn’t technical debt; it’s unmanaged technical debt.

Another way to ensure that people act upon technical debt is by learning to come up with small improvements. A small improvement today is preferable over a better improvement next week.
The reason for that is that you get the compound interest of the improvements day by day, as well as a reduction in interaction effects between various pieces of technical debt. The positive side-effect is that teams learn to think in smaller improvements, which will help them with general feature work too.
- If you can fix it within five minutes, then you should.
- Try to address technical debt by improving your domain model. If that is too involved, you could resort to a technical hack. In the event that that is too involved, try to at least automate the solution. But sometimes even that is too difficult; in this case, make a checklist for the next time.
- Agree on a timebox for the improvement that you introduce with the team. How much time are you willing to invest in a small improvement? That defines your timebox.
- Don’t fix it yourself, if it can be fixed by machines.
- If it is messy because you have a lot of debt, then make it look messy. The visual should inspire change.
- Only people with skin in the game are allowed to pay off debt, in order to prevent solutions that don’t work in practice.

But… how to prioritize the technical debt in the roadmap?

As we can read in this article (https://www.infoq.com/articles/getting-tech-debt-on-roadmap/), in the process of determining how to prioritize and schedule engineering tasks, it's crucial to shift our focus from the specifics of what needs to be done, such as database upgrades, to understanding why these tasks are essential and linking them back to business objectives. For instance, an engineer might argue for a database upgrade because it's reaching its end of life. However, the urgency becomes clear when considering business implications, like a hosting provider's refusal to support an outdated database, threatening the continuity of the product.
*Example:*
Avoid "Upgrade the MySQL database", avoid "Move off of EOL database", use "Ensure product continues to work after 2024-09"
So, the idea here is to try to create a link between the technical debt and the business value. Those debts that have this link crystal clear I would put on top of the list.
In some other cases, where it’s difficult to bring the link to the business value, there is also a way to handle the tech debt which is the impact that it’s causing to deliver other features. For example, pointing out every time that the developer is working in a task and face an issue or a blocker because of that debt.
