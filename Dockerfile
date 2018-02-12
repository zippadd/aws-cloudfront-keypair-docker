FROM alpine:latest

ENV scriptURL https://github.com/zippadd/aws-cloudfront-keypair-docker/blob/master/script/genAndPackKeyPair.sh
###Update packages###
RUN apk update && apk upgrade && apk add --update openssl \
###Install new packages###
#AWS cli
    && apk add py-pip && pip install --upgrade pip \
    && pip install awscli && aws configure set default.region us-west-2
###Get and prep script
    #&& wget
###Generate###
#ENTRYPOINT ["genAndPackKeyPair.sh"]
