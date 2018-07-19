package aws

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/autoscaling"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/umovme/deployee/as"
)

// GetInstances get all instances from a AS group
func (c Config) GetInstances(groupName string) (out []as.Instance, err error) {

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

	if awsOut.AutoScalingGroups == nil {
		return
	}

	instanceIDs := []string{}

	for i := 0; i < len(awsOut.AutoScalingGroups[0].Instances); i++ {
		instance := awsOut.AutoScalingGroups[0].Instances[i]
		instanceIDs = append(instanceIDs, *instance.InstanceId)
	}

	out, err = c.describeInstances(session, instanceIDs...)

	return
}

// describeInstances details a set of instances on an AS Group
func (c Config) describeInstances(session *session.Session, instanceIDs ...string) (out []as.Instance, err error) {

	ec2Service := ec2.New(session)

	resp, err := ec2Service.DescribeInstances(
		&ec2.DescribeInstancesInput{
			Filters: []*ec2.Filter{
				&ec2.Filter{
					Name:   aws.String("instance-id"),
					Values: aws.StringSlice(instanceIDs),
				},
			},
		},
	)

	if err != nil {
		return
	}

	for _, instanceID := range instanceIDs {
		for idx := range resp.Reservations {
			for _, inst := range resp.Reservations[idx].Instances {

				if *inst.InstanceId == instanceID {

					out = append(out, as.Instance{
						ID:         instanceID,
						PrivateDNS: *inst.PrivateDnsName,
						PrivateIP:  *inst.PrivateIpAddress,
						PublicDNS:  *inst.PublicDnsName,
						PublicIP:   *inst.PublicIpAddress,
						// Zone:       inst.AvailabilityZone,
					})

					break
				}
			}
		}
	}
	return
}
