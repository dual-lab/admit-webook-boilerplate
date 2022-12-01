package net

import (
	"encoding/json"
	"fmt"
	"github.com/dual-lab/admit-webook-boilerplate/pkg/webhook"
	"io"
	"k8s.io/api/admission/v1"
	"k8s.io/api/admission/v1beta1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/klog/v2"
	"net/http"
)

// Serve wrappe logic for the http request prior to invoke
// the [webhook.AdmitHandler] function
func Serve(w http.ResponseWriter, r *http.Request, admit webhook.AdmitHandler) {
	var body []byte
	if data, err := io.ReadAll(r.Body); err == nil {
		body = data
	} else {
		klog.V(2).ErrorS(err, "Error reading body request", r.URL)
	}
	contentType := r.Header.Get("Content-Type")
	if contentType != "application/json" {
		klog.Errorf("contentType=%s, expect application/json", contentType)
		return
	}
	klog.V(2).Infof("Handling request %s", body)
	deserializer := webhook.Codecs.UniversalDeserializer()
	obj, gvk, err := deserializer.Decode(body, nil, nil)
	if err != nil {
		msg := fmt.Sprintf("Request could not be decoded: %v", err)
		klog.V(2).ErrorS(err, "Request could not be decoded")
		http.Error(w, msg, http.StatusBadRequest)
		return
	}
	var respObj runtime.Object
	switch *gvk {
	case v1beta1.SchemeGroupVersion.WithKind("AdmissionReview"):
		radr, ok := obj.(*v1beta1.AdmissionReview)
		if !ok {
			klog.Errorf("Expected v1beta1.AdmissionReview but got: %T", obj)
			return
		}
		respAdmissionReview := &v1beta1.AdmissionReview{}
		respAdmissionReview.SetGroupVersionKind(*gvk)
		respAdmissionReview.Response = admit.V1beta1(*radr)
		respAdmissionReview.Response.UID = radr.Request.UID
		respObj = respAdmissionReview
	case v1.SchemeGroupVersion.WithKind("AdmissionReview"):
		radr, ok := obj.(*v1.AdmissionReview)
		if !ok {
			klog.Errorf("Expected v1.AdmissionReview but got: %T", obj)
			return
		}
		respAdmissionReview := &v1.AdmissionReview{}
		respAdmissionReview.SetGroupVersionKind(*gvk)
		respAdmissionReview.Response = admit.V1(*radr)
		respAdmissionReview.Response.UID = radr.Request.UID
		respObj = respAdmissionReview
	default:
		msg := fmt.Sprintf("Unsupported group version kind: %v", gvk)
		klog.Error(msg)
		http.Error(w, msg, http.StatusBadRequest)
		return
	}
	klog.V(2).Info(fmt.Sprintf("sending response: %v", respObj))
	respBytes, err := json.Marshal(respObj)
	if err != nil {
		klog.V(2).ErrorS(err, "error creating resp json object")
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	if _, err := w.Write(respBytes); err != nil {
		klog.V(2).ErrorS(err, "error on response")
	}
}
