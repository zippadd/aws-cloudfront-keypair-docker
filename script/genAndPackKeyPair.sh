#!/bin/sh
openssl genrsa -out cloudfront_key.pem 4096
openssl rsa -in cloudfront_key.pem -pubout > cloudfront_key.pub
