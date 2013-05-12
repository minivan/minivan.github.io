---
layout: post
title: A git alias that inserts a random emoji in the commit message
type: experiment
excerpt: Emojis are fun, so let's put them everywhere!

---

## Premise

Let's write a git alias that would insert a random [Emoji](http://en.wikipedia.org/wiki/Emoji) at the beginning of a git commit message.
Both Github and Bitbucket support emojis, so why not?

## Obtaining the emojis

There's the wonderful [cheat sheet](http://www.emoji-cheat-sheet.com/) for all the supported emojis, so I'll use that. But first, we'll need a little gem.
{% highlight bash %}
gem install nokogiri
{% endhighlight %}
I used Nokogiri to parse the HTML on the cheat sheet site, but you may be more comfortable with the (almost dead) [hpricot](https://github.com/hpricot/hpricot).

So, let's fire up IRB and write the following:
{% highlight ruby %}
require 'nokogiri'
require 'open-uri'
page = Nokogiri::HTML(open('http://www.emoji-cheat-sheet.com/'))
{% endhighlight %}

Now that we have the page, let's look at the data we need to get to. Open the developer tools and find in what way can we get access to the names of the emojis.

![Here's the data we need to get to](/assets/images/emoji-1.png)

As it turns out, all the data we need has the `name` class. So, we can obtain an array of all the emojis by writing the following query:
{% highlight ruby %}
emojis = page.css('.name').map(&:content)
{% endhighlight %}

What we do here is take all the nodes that have a `name` class and receive a `Nokogiri::XML::NodeSet`. It turns out that the `NodeSet` includes the `Enumerable`, so we can `map` it. To get the content from a Nokogiri Node, we just have to send `content` to the node and using the symbol-to-proc, we get to the line of code shown above.

The next step is to write the emojis to a file. Easy:
{% highlight ruby %}
File.open('emojis.txt', 'w') {|f| f.write(emojis.join(' '))}
{% endhighlight %}

We now have a file that contains all the emojis separated by spaces. Let's move on.

## Picking the emoji

Since most users don't have Ruby on their systems, the script has to be written in Bash. Well, I wouldn't mind learning some Bash anyway.

So, the aim is to select a random emoji from this list of strings.
Let's create a file `emoji.sh` in the home dir and put the hashbang in it:
{% highlight bash %}
#!/bin/bash
{% endhighlight %}

Now we need to initialize an array of words and count them. Let's start by:
{% highlight bash %}
emojis=( bowtie smile tshirt moon )
num_emojis=${#emojis[*]}
echo "${emojis[$((RANDOM%num_emojis))]}"
{% endhighlight %}
Save and run using `source emoji.sh`. If you see one of the four up there, everything's great. Now let's take all the data and put them in here (we don't want a lot of files just laying around). What we get is similar to this:
{% highlight bash %}
#!/bin/bash
emojis=( bowtie smile laughing blush smiley relaxed smirk ... )
num_emojis=${#emojis[*]}
echo "${emojis[$((RANDOM%num_emojis))]}"
{% endhighlight %}

And that's it! If you don't want to go through all these steps, [here's the final script](/assets/files/emoji.sh).

## The git alias itself

That's the easiest one: find the `.gitconfig` file in your home directory (or create one) and write:

    [alias]
      cj = !bash -c 'git commit -m \":`. ~/emoji.sh`: $0\"'

This requires some explanation:

- We invoke a `bash` command using `!bash -c '...'`. Actually, it would be more useful te rewrite the script using `sh`, so that any system would support it.
- We do the regular `git commit -m "..."`. Since we need to pass several words to `commit`, we escape the quotes.
- By now we have `!bash -c 'git commit -m \"...\"'`
- Inside the string we need to have: the emoji surrounded by colons and the commit message, which is sent as an argument to the `git cj`. So, the command will now look like `!bash -c 'git commit -m \":<obtain_emoji>: $0\"'` ($0 yields the first argument.)
- Now let's obtain the emoji. Since we're in `bash` now and the script is also in bash, we can use the `source` command, or `.` for short. The script echoes, so upon sourcing it we'll get a string and that's what we need!
- And this is how we obtain the alias we wrote above.

Here's an example of how it looks like on GitHub:

![Oh, and here's a repo!](/assets/images/emoji-2.png)

That's it! We now have a git alias that would insert random emojis in the commits. That's utterly pointless, but it's fun!






