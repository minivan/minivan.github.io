---
layout: post
title: My personal Rails quickstart
type: post
excerpt: Get quickly to building the prototype without messing with the details
---

If there's one things Rails is very good for, it's prototyping. When you know it, Rails becomes a powerful tool for testing ideas, prototyping interfaces and concepts.

Starting a new Rails app is easy, especially with projects like [Rails Apps Composer](https://github.com/RailsApps/rails-composer) and [RailsBricks](http://www.railsbricks.net/). Although these projects are great, I find myself growing more comfortable with a strong, simple base project for my apps. And having used it more and more recently, I decided to share it.

It uses the following:

- Rails 4.2
- PostgreSQL as a database
- Turbolinks are removed (yay!)
- [RSpec](https://github.com/rspec/rspec-rails) for writing specs
- [Capybara](https://github.com/jnicklas/capybara) for proper acceptance testing. I use [poltergeist](https://github.com/teampoltergeist/poltergeist) to test using PhantomJS.
- [Settingslogic](https://github.com/binarylogic/settingslogic) to store the settings
- [Zurb Foundation](http://foundation.zurb.com/) as a frontend framework

I usually simply `git clone` the fresh repo into a directory. Although the app name is still "Rails-Quickstart", that's not usually a problem, especially for quick prototyping objects. Also, Zurb provides a set of excellent [templates](foundation.zurb.com/templates.html) that can be plugged right into the fresh app, so I can start focusing on the features.

Now all I have to do is run 

    git clone git@github.com:minivan/rails-quickstart.git
