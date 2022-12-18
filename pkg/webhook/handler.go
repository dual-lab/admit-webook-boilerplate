package webhook

import (
	"k8s.io/api/admission/v1"
	"k8s.io/api/admission/v1beta1"
)

// AdmitHandler wrap different type version of AdmissionReview object
//
type AdmitHandler struct {
    V1beta1 AdmitV1Beta1Func
    V1      AdmitV1Func
}

func WrapToAdminV1(f AdmitV1Func) AdmitHandler {
    return AdmitHandler{
        V1: f,
        V1beta1: delegateV1beta1ToV1(f),
		}
}

func delegateV1beta1ToV1(f AdmitV1Func) AdmitV1Beta1Func {
    return func(review v1beta1.AdmissionReview) *v1beta1.AdmissionResponse {
        return convertToV1Beta1AdmissionRespone(f(v1.AdmissionReview{Request: convertToV1AdmissionRequest(review.Request)}))
		}
}

// AdmitV1Func handler for v1 Admission version
type AdmitV1Func func(review v1.AdmissionReview) *v1.AdmissionResponse
// AdmitV1Beta1Func hadnler for v1beta1 Admission version
type AdmitV1Beta1Func func(review v1beta1.AdmissionReview) *v1beta1.AdmissionResponse
