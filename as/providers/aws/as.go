package aws

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/autoscaling"
	deployee_as "github.com/umovme/deployee/as"
)

// ListGroups lists all autocalling groups in the region
func (c Config) ListGroups() (out []deployee_as.GroupDetails, err error) {

	session, err := c.prepareSession()
	if err != nil {
		return
	}

	as := autoscaling.New(session)

	awsOut, err := as.DescribeAutoScalingGroups(
		&autoscaling.DescribeAutoScalingGroupsInput{},
	)

	if err != nil {
		return
	}

	for i := 0; i < len(awsOut.AutoScalingGroups); i++ {

		out = append(out, deployee_as.GroupDetails{
			Name:    *awsOut.AutoScalingGroups[i].AutoScalingGroupName,
			Minimum: int32(*awsOut.AutoScalingGroups[i].MinSize),
			Maximum: int32(*awsOut.AutoScalingGroups[i].MaxSize),
			Current: int32(*awsOut.AutoScalingGroups[i].DesiredCapacity),
		})
	}

	return
}

// UpdateGroup updates AS group configuration
func (c Config) UpdateGroup(group deployee_as.GroupDetails) (err error) {

	session, err := c.prepareSession()
	if err != nil {
		return
	}

	as := autoscaling.New(session)

	_, err = as.UpdateAutoScalingGroup(
		&autoscaling.UpdateAutoScalingGroupInput{
			AutoScalingGroupName: aws.String(group.Name),
			MaxSize:              aws.Int64(int64(group.Maximum)),
			MinSize:              aws.Int64(int64(group.Minimum)),
			DesiredCapacity:      aws.Int64(int64(group.Current)),
		},
	)

	return
}