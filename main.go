package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/umovme/deployee/as"

	"github.com/gorilla/mux"
	"github.com/umovme/deployee/as/providers/aws"
)

func main() {

	fmt.Printf("Deployee v2\n")

	r := mux.NewRouter()
	r.HandleFunc("/groups", allGroups)
	http.Handle("/", r)

	log.Fatal(http.ListenAndServe(":3001", nil))
}

func allGroups(w http.ResponseWriter, r *http.Request) {

	provider := aws.Config{
		Region: "us-east-1",
	}

	result, err := getGroups(provider)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	w.Header().Set("Content-Type", "application/json")

	json.NewEncoder(w).Encode(result)

}

func getGroups(prop as.Group) (out []as.GroupDetails, err error) {

	out, err = prop.ListGroups()

	return
}
