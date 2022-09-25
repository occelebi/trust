package main

import (
	"strings"
)

func reoccurrence(s string) map[string]int {

	i := strings.SplitAfter(s, "")
	cc := make(map[string]int)
	for _, s := range i {
		_, g := cc[s]
		if g {
			cc[s] += 1
		} else {
			cc[s] = 1
		}
	}
	return cc
}
