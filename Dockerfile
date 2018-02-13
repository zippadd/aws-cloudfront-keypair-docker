FROM alpine:latest

ENV scriptURL https://raw.githubusercontent.com/zippadd/aws-cloudfront-keypair-docker/master/script/genAndPackKeyPair.sh
ENV scriptFilePath genAndPackKeyPair.sh
###Update packages###
RUN apk update && apk upgrade && apk add --update openssl \
###Install new packages###
#AWS cli
    && apk add py-pip && pip install --upgrade pip \
    && pip install awscli && aws configure set default.region us-west-2 \
###Get and prep script
    && wget -O $scriptFilePath $scriptURL \
    && chmod 755 $scriptFilePath
###Generate###
ENTRYPOINT ["/genAndPackKeyPair.sh"]
