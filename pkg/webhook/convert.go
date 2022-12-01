package webhook

import (
	v1 "k8s.io/api/admission/v1"
	"k8s.io/api/admission/v1beta1"
)

// convertToV1AdmissionRequest convert v1beta.AdmissionRequest -> v1.AdmissionRequest
//
func convertToV1AdmissionRequest(request *v1beta1.AdmissionRequest) *v1.AdmissionRequest {
	return &v1.AdmissionRequest{
		Kind:               request.Kind,
		Namespace:          request.Namespace,
		Name:               request.Name,
		Object:             request.Object,
		Resource:           request.Resource,
		Operation:          v1.Operation(request.Operation),
		UID:                request.UID,
		DryRun:             request.DryRun,
		OldObject:          request.OldObject,
		Options:            request.Options,
		RequestKind:        request.RequestKind,
		RequestResource:    request.RequestResource,
		RequestSubResource: request.RequestSubResource,
		SubResource:        request.SubResource,
		UserInfo:           request.UserInfo,
	}
}

// convertToV1Beta1AdmissionRespone convert v1.AdmissionResponse -> v1beta1.AdmissionResponse
//
func convertToV1Beta1AdmissionRespone(response *v1.AdmissionResponse) *v1beta1.AdmissionResponse {
	var pt *v1beta1.PatchType
	if response.PatchType != nil {
		t := v1beta1.PatchType(*response.PatchType)
		pt = &t
	}
	return &v1beta1.AdmissionResponse{
		UID:              response.UID,
		Allowed:          response.Allowed,
		AuditAnnotations: response.AuditAnnotations,
		Patch:            response.Patch,
		PatchType:        pt,
		Result:           response.Result,
		Warnings:         response.Warnings,
	}
}
