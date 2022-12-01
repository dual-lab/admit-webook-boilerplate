package net

import (
	"io"
	"net/http"
)

// Readyz handle function to implement readiness probe
//
func Readyz(w http.ResponseWriter, r http.Request) {
	_, _ = io.WriteString(w, "ok")
}
