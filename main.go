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
	apiRouter.HandleFunc("/groups/{id}", editGroup).Methods("OPTIONS", "PUT")
	apiRouter.HandleFunc("/groups/{id}", showGroup).Methods("GET")
	apiRouter.HandleFunc("/regions", allRegions)

	// static files on `./static` dir
	r.PathPrefix("/ui").Handler(
		http.StripPrefix("/ui/", http.FileServer(
			http.Dir("static"))))

	// redirects '/' to '/ui/'
	r.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		http.Redirect(w, r, "/ui/", http.StatusFound)
	})

	http.Handle("/", r)

	log.Fatal(http.ListenAndServe(":3001", logRequest(http.DefaultServeMux)))
}

//TODO refactor this shit
func showGroup(w http.ResponseWriter, r *http.Request) {
	provider := getProvider(r)

	vars := mux.Vars(r)
	groupName := vars["id"]

	result, err := func(prop as.Group) (as.GroupDetails, error) {
		return prop.Describe(groupName)
	}(provider)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(result)
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

	err = func(prop as.Group, group as.GroupDetails) error {
		return prop.UpdateGroup(group)
	}(provider, data)

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

	result, err := func(prop as.Group) ([]as.GroupDetails, error) {
		return prop.ListGroups()
	}(provider)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(result)

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

func allRegions(w http.ResponseWriter, r *http.Request) {

	type region struct {
		Name       string `json:"name"`
		PrettyName string `json:"pretty"`
	}

	result := []region{
		region{Name: "sa-east-1", PrettyName: "South Brazil"},
		region{Name: "us-east-1", PrettyName: "North Virginia"},
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(result)
}
