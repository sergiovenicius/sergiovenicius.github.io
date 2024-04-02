---
title: "Mutation Tests / Testing"
date: 2023-05-03 00:00:00 -0300
categories: [Dev]
tags: [Dev]
---

Recently I was taking a course in Software Engineering and Quality, and I read about mutation tests.

It is something related to how much quality your unit tests have while they are really covering your code.

Imagine that you have 100% of code coverage, and it’s really fine and nice, then a developer comes and changes a condition in a method which changes the possible results of it, but the unit test covering that method is not seen as affected while running the unit tests (because it uses a specific value and the method still works correctly with that value, but in case of other values it starts accepting, and should not). The unit test doesn’t cover many different cases, but as the unit test exists, the code coverage is still 100%. That goes to production, and boom! Bugs!

What is really the quality of all those unit tests covering 100% of code?

Here comes the mutation tests check. In .net, there is an extension called “dotnet stryker”, which helps developers to find out this kind of issues with unit tests.

Imagine an extension checking your code and inserting some operators as:

arithmetic, equality, logical, boolean, assignments, and lots of others.

I mean, the extension checks your methods creating mutations in it, like changing + by -, > by >=, && by ||, !person.IsAdult() by person.IsAdult(), and rerun the unit tests over each mutation. Changes that a developer could make easily someday (< by <=), and having the same issue as the example.

For every mutation tested and not reported by any unit test, a report is generated showing the mutation and also what happened.

The report generation takes some time, but it is worth it.

That is a really awesome way to create quality unit tests and really protect your code from production errors.

You can find the extension “dotnet stryker” here: https://stryker-mutator.io/docs/stryker-net/operating-modes/

To use it, you first need to install in your machine:
dotnet tool install –global dotnet-stryker –version 3.6.1

and to use it, navigate to your solution folder, and call it with the command below:
dotnet-stryker -s solution.sln

You can see the mutations running and also the report generated in the images:

![Example 1](/assets/mutation-example1.png "Example 1")


![Example 2](/assets/mutation-example2.png "Example 2")


below, you can see that the mutation “survived”, because the mutation (<= instead of <) is not covered by any unit tests. So if a developer does this change, it won’t be identified and it may cause any malfunction in the application.

![Example 3](/assets/mutation-example3.png "Example 3")


Below, there is a different case, where the mutation may cause timeout.


![Example 4](/assets/mutation-example4.png "Example 4")
