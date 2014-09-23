# AWS Auto Scaling Deployment

#### An api to deploy using the auto scaling on AWS

## AWS Ruby SDK Documentation
http://docs.aws.amazon.com/AWSRubySDK/latest/_index.html

## Setup
Intall bundle: gem install bundle
Run 'bundle install' command to install dependencies

Configure AWS credentials (http://docs.aws.amazon.com/AWSSdkDocsRuby/latest/DeveloperGuide/ruby-dg-setup.html#set-up-creds)

## How to run
Execute deploy.rb passing as argument the name of the auto scaling group. For example:

```
#!ruby

ruby deploy.rb -g my_group

```

## How it works?
This script removes the instances that contain the old version of the application. After removing an instance he will wait for the auto scaling group instantiate another. The process is repeated until all instances containing the old version of application be renewed. 

The script assumes that new instances in the auto scaling group come with the new version of the application. Its only function is to exchange instances.
