FROM alpine:latest

###Update packages###
RUN apk update && apk upgrade \
    && npm install npm@latest -g && apk add --update openssl \
###Install new packages###
#AWS cli
    && apk add py-pip && pip install --upgrade pip \
    && pip install awscli && aws configure set default.region us-west-2 \
