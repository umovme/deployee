package main

import (
	"fmt"

	"github.com/umovme/deployee/as"

	"github.com/umovme/deployee/as/providers/aws"
)

func main() {

	provider := aws.Config{
		Region: "us-east-1",
	}

	fmt.Printf("Deployee v2\n")
	printAS("xxxx", provider)
	// printAS("AS-uMov-Sync_Photo", provider)
	// printAS("as-uMov-Sync_dados", provider)
}

func printAS(name string, group as.Group) {

	count, err := group.Length(name)

	if err != nil {
		panic(err)
	}
	fmt.Printf("%s contain %d instances\n", name, count)
}
