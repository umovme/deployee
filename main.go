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

	apiRouter := r.PathPrefix("/api").Subrouter()
	apiRouter.HandleFunc("/groups", allGroups)
	apiRouter.HandleFunc("/groups/{id}", editGroup).Methods("OPTIONS", "GET", "PUT")

	http.Handle("/", r)

	log.Fatal(http.ListenAndServe(":3001", logRequest(http.DefaultServeMux)))
}

func editGroup(w http.ResponseWriter, r *http.Request) {
	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusNoContent)
		return
	}

	decoder := json.NewDecoder(r.Body)

	var data as.GroupDetails
	err := decoder.Decode(&data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")

	provider := getProvider(r)

	err = updateGroup(provider, data)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	json.NewEncoder(w).Encode(data)

}

func logRequest(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s %s\n", r.RemoteAddr, r.Method, r.URL)
		handler.ServeHTTP(w, r)
	})
}

func allGroups(w http.ResponseWriter, r *http.Request) {

	provider := getProvider(r)

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

func updateGroup(prop as.Group, group as.GroupDetails) (err error) {
	err = prop.UpdateGroup(group)
	return
}

func getProvider(r *http.Request) aws.Config {

	region := r.URL.Query().Get("region")

	provider := aws.Config{
		Region: "sa-east-1",
	}

	if region != "" {
		provider.Region = region
	}

	return provider
}
