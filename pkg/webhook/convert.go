package webhook

import (
	v1 "k8s.io/api/admission/v1"
	"k8s.io/api/admission/v1beta1"
)

// convertToV1AdmissionRequest convert v1beta.AdmissionRequest -> v1.AdmissionRequest
// FIXME: implement me
func convertToV1AdmissionRequest(request *v1beta1.AdmissionRequest) *v1.AdmissionRequest {
	return &v1.AdmissionRequest{}
}

// convertToV1Beta1AdmissionRespone convert v1.AdmissionResponse -> v1beta1.AdmissionResponse
// FIXME: implement me
func convertToV1Beta1AdmissionRespone(response *v1.AdmissionResponse) *v1beta1.AdmissionResponse {
	return &v1beta1.AdmissionResponse{}
}
