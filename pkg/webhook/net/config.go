package net

import (
	"crypto/tls"
	"k8s.io/klog/v2"
)

// TLSConfig struct to configure tls key and cert
//
type TLSConfig struct {
	CertFile string
	KeyFile  string
}

// Load load a cert and key pem file into a tls.Config structure
//
func (receiver TLSConfig) Load() *tls.Config {
	sCert, err := tls.LoadX509KeyPair(receiver.CertFile, receiver.KeyFile)
	if err != nil {
		klog.Fatal(err)
	}
	return &tls.Config{
		Certificates: []tls.Certificate{sCert},
	}
}
