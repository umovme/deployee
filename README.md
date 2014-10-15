# Deployee

A tool to simplify deployments using AWS auto scaling engine.

## How it works?

#### How deployments should work? 
The autoscaling engine allows us a new concept of deployment. 
Basically we promote a new version of an application. When a new instance of an AMI is created, during setup, the latest version of the promoted application is installed on this machine via script.
In this model, the concept of deployment is only renew existing machines of a group of scalability.

#### How the deployment is done (here the magic happens)
We assume that the issue of promotion and setup is already solved in the setup of AMI.
This tool helps you to renew all instances of a scale group.
There are several ways to renew instances. We call these ways of strategies. Below is a list of the available strategies. Feel the urge to create your own strategy and send us a pull request.


* [At Least One](https://github.com/robsonbittencourt/deployee/wiki/At-Least-One)
* [Blackout](https://github.com/robsonbittencourt/deployee/wiki/Blackout)
* [Computing Preserve](https://github.com/robsonbittencourt/deployee/wiki/Computing-Preserve)
* [Double Capacity](https://github.com/robsonbittencourt/deployee/wiki/Double-Capacity)

## Setup
Install bundle `gem install bundle`

Run `bundle install` command to install dependencies listed on `Gemfile`

[Configure AWS credentials](http://docs.aws.amazon.com/AWSSdkDocsRuby/latest/DeveloperGuide/ruby-dg-setup.html#set-up-creds)

## Running
Execute deploy.rb passing as argument the name of the auto scaling group. 

For example:
`ruby deploy.rb -g my_group`

## Resources
[AWS Ruby SDK Documentation](http://docs.aws.amazon.com/AWSRubySDK/latest/_index.html)

## License
The MIT License (MIT)

Copyright (c) 2014 uMov.me

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
