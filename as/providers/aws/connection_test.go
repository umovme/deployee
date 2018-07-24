package aws

import (
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/go-test/deep"
)

type fields struct {
	Region string
	Key    string
	Secret string
}

func TestConfig_prepareSession(t *testing.T) {
	conf := fields{Region: "us-east-1"}
	tests := []struct {
		name     string
		fields   fields
		wantSess *session.Session
		wantErr  bool
	}{
		{name: "error when region is missing", wantErr: true},
		{name: "ok when set region", fields: conf, wantSess: session.New(&aws.Config{Region: &conf.Region}), wantErr: false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := Config{
				Region: tt.fields.Region,
				Key:    tt.fields.Key,
				Secret: tt.fields.Secret,
			}
			gotSess, err := c.prepareSession()
			if (err != nil) != tt.wantErr {
				t.Errorf("Config.prepareSession() error = %#v, wantErr %#v", err, tt.wantErr)
				return
			}

			if diff := deep.Equal(gotSess, tt.wantSess); diff != nil {
				t.Errorf("Config.prepareSession() = %#v", diff)
			}
		})
	}
}
