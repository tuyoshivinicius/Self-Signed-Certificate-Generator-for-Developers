#!/bin/bash

hostname=$1
password="$2"

# Verificando argumentos requeridos
if [[ -n "$hostname" && -n "$password" ]]; then
    

    if [ ! -f "mkcert" ]; then
        
        curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
        chmod +x mkcert-v*-linux-amd64
        cp mkcert-v*-linux-amd64 mkcert
        rm -rf mkcert-v*-linux-amd64
        chmod +x mkcert

    else
        echo "mkcert instalado"
    fi

    ./mkcert "$hostname"
    
    # convertendo pra p12 com senha
    openssl pkcs12 -export -inkey "${hostname}-key.pem" -in "${hostname}.pem" -out "${hostname}.p12" -password "pass:${password}"

    # convertendo pra crt (DER)
    openssl x509 -inform PEM -in "${hostname}.pem" -outform DER -out "${hostname}.crt"
    openssl rsa -inform PEM -in "${hostname}-key.pem" -outform DER -out "${hostname}.key"

    # convertendo pra cer (DER)
    openssl x509 -inform PEM -in "${hostname}.pem" -outform DER -out "${hostname}.cer"
    openssl rsa -inform PEM -in "${hostname}-key.pem" -outform DER -out "${hostname}-key.cer"

    

else
    echo "é necessario passar o host e password"
fi


