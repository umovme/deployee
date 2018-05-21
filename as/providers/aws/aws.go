package aws

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/autoscaling"
)

// Config contains a AWS Configuration
type Config struct {
	Region string
	Key    string
	Secret string
}

var ()

// Length get a instance count for a AS Group
func (c Config) Length(groupName string) (instanceCount int32, err error) {

	session, err := c.prepareSession()
	if err != nil {
		return
	}

	as := autoscaling.New(session)

	awsOut, err := as.DescribeAutoScalingGroups(
		&autoscaling.DescribeAutoScalingGroupsInput{
			AutoScalingGroupNames: aws.StringSlice([]string{groupName}),
		},
	)

	if err != nil {
		return
	}

	instanceCount = int32(*awsOut.AutoScalingGroups[0].DesiredCapacity)

	return
}
