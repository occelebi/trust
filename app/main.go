package main

import (
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"context"
	"flag"
	"os"
	"os/signal"
	"time"
)

func main() {

	var wait time.Duration
	flag.DurationVar(&wait, "graceful-timeout", time.Second * 15, "the duration for which the server gracefully wait for existing connections to finish")
	flag.Parse()

	r := mux.NewRouter()
	r.HandleFunc("/", handler).Methods("PUT")

	srv := &http.Server{
	    Addr:         "0.0.0.0:8080",
	    Handler:      r,
	    ReadTimeout:  time.Second * 10,
	    WriteTimeout: time.Second * 15,
	    IdleTimeout:  time.Second * 60,
	}

	go func() {
	    if err := srv.ListenAndServe(); err != nil {
	        log.Println(err)
	    }
	}()

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	<-c

	ctx, cancel := context.WithTimeout(context.Background(), wait)
	defer cancel()

	srv.Shutdown(ctx)

	log.Println("shutting down")
	os.Exit(0)
}
