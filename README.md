# AWS Auto Scaling Deployment

A tool to simplify deployments using AWS auto scaling engine.

## How it works?

#### How deployments should work? 
The autoscaling engine allows us a new concept of deployment. 
Basically we promote a new version of an application. When a new instance of an AMI is created. During setup, the latest version of the promoted application is installed on this machine via script.
In this model, the concept of deployment is only renew existing machines of a group of scalabilidade.

#### How the deployment is done (here the magic happens)
We assume that the issue of promotion and setup is already solved in the setup of AMI.
This tool helps you to renew all instances of a scale group.
They will increment the min and max limit of instancies in the scale-group to preserve the computational power of this group. Then will terminate and renew each old instance as well featuring a full deployment.

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
