package aws

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
)

var (
	sess *session.Session
)

func (c Config) prepareSession() (sess *session.Session, err error) {
	sess, err = session.NewSession(
		&aws.Config{
			Region: aws.String(c.Region),
		})

	return
}
