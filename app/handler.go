package main

import (
	"fmt"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	length := r.ContentLength

	if length < 2 {
		http.Error(w, "Error: please compose a string with at least two characters", http.StatusBadRequest)
		return
	}

	req_body := make([]byte, length)
	r.Body.Read(req_body)

	log.Printf("%s request - %s: '%s'\n", r.Method, r.RemoteAddr, string(req_body))

	for k, v := range reoccurrence(string(req_body)) {
		if v >= 2 {
			fmt.Fprintln(w, v, "times", k)
		}
	}
	fmt.Fprintln(w, "Text provided:", string(req_body))
}
