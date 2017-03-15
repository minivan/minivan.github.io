---
layout: post
title: Efficient analytics with Redis bitmaps
type: experiment
excerpt: How can we leverage a data structure to measure things fast

---

[Redis](https://redis.io/) is an in-memory data structure store that often surprises by its simplicity.

Today I'd like to talk a bit about a feature called Bitmaps and how we can leverage that to build simple and efficient analytics.

---

Let's say we would like to measure user retention in our app. One of the ways to do this is to track, for all users, how likely it is that they signed in this week given that they signed in last week. So how can we do that?

One of the ways to do that is to store all the user sessions in the database. Whenever a user signs in, we create a session and whenever we want to generate a report, we query the table with a complicated SQL query. If we want the question to be asked only by week, then we would probably have to denormalize the database, introducing additional columns that would make the querying easier.

Another, much simpler way is to use Redis' bitmaps.

If you've never worked with Redis before, it's not that difficult. Redis is an in-memory data structure store. Think of it like a dictionary, or a hash map, that runs as a service alongside your database. It stores a value of a certain type that can be accessed using a certain key. Redis has several data types and you can send a set of commands to the Redis server to make it execute certain things. For example, you can send the SET command with a key and a value and Redis will store it. You can later send the GET command with the same key get the value back. Some commands only work for some data types — for example, you can send the INCR command to increment an integer key, but if you send it on a list, it won't work. Redis also has clients for every language out there, including Visual Basic and their interface mostly resembles the commands interface.

Bitmap is one of the types that Redis offers with two basic commands: SETBIT and GETBIT.

By default, all the bits in a bitmap are equal to 0. We can send the SETBIT command to set a key's specific position to 1. We can use the GETBIT command to get the value of a key's specific position, and the bitmaps can store up to 2^32 bits, which is about 4 billion.

So with an ID of a user, we can set the bit of a key for last week using the SETBIT command whenever a user logs in.

> SETBIT user-logins:2017-week-11 456456 1

Or, if we're using a client library, for example for [Java](https://github.com/xetorthio/jedis):

    boolean bit = jedis.setbit("user-logins:2017-week-11", 456456, true);

The bit inside the bitmap representation corresponding to the user will be set to 1. At any time we can count the number of users who logged in last week using the `bitcount` command:

    long countLastWeek = jedis.bitcount("user-logins:2017-week-11")

This command performs a very fast count of ones in the `user-logins` key and returns the result.

So how can we leverage this approach to do better analytics? Whenever we have two bitmaps, we can perform bitwise operations on those. For example, if we have the logins for week 11 and week 12 of the year, we can use the BITOP command to do a bitwise AND and store the results in a different key.

    jedis.bitop("user-logins:2017-week-11", "user-logins:2017-week-12", "user-logins:2017-week-11-12")

Then, we can get the count of people who logged in during week 11 by sending a bitcount to the original key:

    long countLastWeek = jedis.bitcount("user-logins:2017-week-11")

And count the number of people who logged in during week 11 and 12 by sending a bitcount to the newly obtained key:

    long countBothWeeks = jedis.bitcount("user-logins:2017-week-11-12")

This gives us a single number that we can use to measure the retention, but more importantly, we can obtain this number in an efficient way.


