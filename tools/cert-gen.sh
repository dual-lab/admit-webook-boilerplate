#!/bin/bash
#############################################
## Generate cert + key
## to use for our custom admission webhhook
#############################################

set -euo pipefail
DAYS=365
function generateCA(){
#	CREATE THE PRIVATE KEY FOR OUR CUSTOM CA
openssl genrsa -out ${out_dir}/admission_ca.key 2048

# GENERATE A CA CERT WITH THE PRIVATE KEY
openssl req -new -x509 -days $DAYS -key ${out_dir}/admission_ca.key -out ${out_dir}/admission_ca.pem -config ${CONFIG_DIR}/ca-config.txt
CA_KEY="${out_dir}/admission_ca.key"
CA_CERT="${out_dir}/admission_ca.pem"
}

function generateCert() {
# CREATE THE PRIVATE KEY
openssl genrsa -out ${out_dir}/admission_key.pem 2048

# CREATE A CSR
openssl req -new -key ${out_dir}/admission_key.pem -subj "/CN=<service-name>.<namespace>.svc" -out ${out_dir}/admission_csr.csr -config ${CONFIG_DIR}/cert-config.txt

# CREATE THE CERT SIGNING THE CSR WITH THE CA
openssl x509 -req -days $DAYS -extfile ${CONFIG_DIR}/v3.ext -in ${out_dir}/admission_csr.csr -CA ${CA_CERT} -CAkey ${CA_KEY} -CAcreateserial -out ${out_dir}/admission_crt.pem

printf "Copy the CA BUNDLE on webhook configuration\n"
cat ${out_dir}/admission_ca.pem | base64 | tr -d '\n'
}


if [ -z ${CONFIG_DIR+x} ] || [ ! -f ${CONFIG_DIR} ]; then
	printf "Config file not specified, set variable CONFIG_DIR %s\n" ${CONFIG_DIR}
	exit 1
fi

out_dir=${OUT_DIR:=build}/certs

mkdir -p ${out_dir}

if [ -z ${CA_KEY+x} ] && [ -z ${CA_CERT+x} ]; then
	printf "Generate CA KEY\n"
	generateCA
  printf "Generate CA cert\n"
	generateCert
else
	printf "Use existiong CA\n"
	generateCert
fi
