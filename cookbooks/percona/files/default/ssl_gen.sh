#!/bin/bash
cd /etc/mysql

# Generate the server key and certificate:
openssl req -x509 -newkey rsa:1024 -keyout server-key-enc.pem -out server-cert.pem -subj '/DC=com/DC=swapslider/CN=server' -passout pass:qw3rty
openssl rsa -in server-key-enc.pem -out server-key.pem -passin pass:qw3rty -passout pass:

# Generate the client key and certificate:
openssl req -x509 -newkey rsa:1024 -keyout client-key-enc.pem -out client-cert.pem -subj '/DC=com/DC=swapslider/CN=client' -passout pass:qw3rty
openssl rsa -in client-key-enc.pem -out client-key.pem -passin pass:qw3rty -passout pass:

# Combine the client and server certificates into the CA certificates file:
cat server-cert.pem client-cert.pem > ca.pem
