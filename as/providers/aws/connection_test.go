package aws

import (
	"reflect"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
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

			// fmt.Printf("v1: %s\nv2: %s\n", reflect.TypeOf(gotSess).String(), reflect.TypeOf(tt.wantSess).String())

			if !reflect.DeepEqual(gotSess, tt.wantSess) {
				// t.Errorf("\n%#v\n%#v", gotSess, tt.wantSess)
				t.Errorf("Config.prepareSession() = %#v\n want %#v", gotSess, tt.wantSess)
			}
		})
	}
}
