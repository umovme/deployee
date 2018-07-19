package aws

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/autoscaling"
	deployee_as "github.com/umovme/deployee/as"
)

// ListGroups lists all autocalling groups in the region
func (c Config) ListGroups() ([]deployee_as.GroupDetails, error) {
	return findGroups(c, nil)
}

func findGroups(c Config, groupName *string) (out []deployee_as.GroupDetails, err error) {
	session, err := c.prepareSession()
	if err != nil {
		return
	}

	as := autoscaling.New(session)

	filter := &autoscaling.DescribeAutoScalingGroupsInput{}

	if groupName != nil {
		filter.AutoScalingGroupNames = aws.StringSlice([]string{*groupName})
	}

	awsOut, err := as.DescribeAutoScalingGroups(filter)

	if err != nil {
		return
	}

	for i := 0; i < len(awsOut.AutoScalingGroups); i++ {

		fmt.Printf("*awsOut.AutoScalingGroups[i]: %#v\n", *awsOut.AutoScalingGroups[i])

		updating := false
		totalInstances := int32(len(awsOut.AutoScalingGroups[i].Instances))
		desired := int32(*awsOut.AutoScalingGroups[i].DesiredCapacity)
		if totalInstances > desired || totalInstances < desired {
			updating = true
		}
		fmt.Printf("*awsOut.AutoScalingGroups[i].Instances): %#v\n", len(awsOut.AutoScalingGroups[i].Instances))
		out = append(out, deployee_as.GroupDetails{
			Name:     *awsOut.AutoScalingGroups[i].AutoScalingGroupName,
			Minimum:  int32(*awsOut.AutoScalingGroups[i].MinSize),
			Maximum:  int32(*awsOut.AutoScalingGroups[i].MaxSize),
			Current:  desired,
			Updating: updating,
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

// Describe a group in AWS
func (c Config) Describe(groupName string) (out deployee_as.GroupDetails, err error) {

	list, err := findGroups(c, &groupName)

	if len(list) == 0 {
		err = fmt.Errorf("Grupo '%s' não foi encontrado", groupName)
		return
	}

	out = list[0]

	return
}
