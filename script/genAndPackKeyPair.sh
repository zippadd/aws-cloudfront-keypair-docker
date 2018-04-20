#!/bin/sh
# Required variables
# regions - array of AWS regions to process against
# AWS_ACCESS_KEY_ID - AWS key id to perform AWS service requests with
# AWS_SECRET_ACCESS_KEY - AWS key id to perform AWS service requests with
# Unused (currently) variables
# keyId - set to an appropriate KMS key id, ARN, or alias

regions=`cat /regions`

if [ "$regions" == "" ]
then
  echo "Unable to find a regions file. Falling back to manual input..."
  read -p "Enter all regions to deploy to (use space as separator): " regions
  for region in $regions; do echo $region >> /regions; done
fi

#Generate keypair
openssl genrsa -out cloudfront_key.pem 4096 &> /dev/null
privateKey=`cat cloudfront_key.pem`
openssl rsa -in cloudfront_key.pem -out cloudfront_key.pub -pubout &> /dev/null
publicKey=`cat cloudfront_key.pub`

echo ""
echo "Public Key (e.g. for import; suitable for PEM file):"
echo "$publicKey"
echo ""
echo "Private Key (PKCS1 format, suitable for PEM file)"
echo "$privateKey"
echo ""

#Convert to PKCS8, remove header/footer, and decode to binary to prep for encryption
openssl pkcs8 -topk8 -nocrypt -in cloudfront_key.pem | sed '1d;$d' | base64 -d > cloudfront_key_sanshf_bPKCS8.pem

#Get param name
read -p "Enter the AWS SSM parameter name (cloudfront access key id recommended): " ssmParamName

export ssmParamName
export privateKey
cat "/regions" | parallel --delay 1 --env ssmParamName --env privateKey --no-notice 'aws configure set region {} \
  && echo {} \
  && aws ssm put-parameter --name "$ssmParamName" --description "Cloudfront KeyPair Private Key PKCS1" --value "$privateKey" --type SecureString'
#if [ "$keyId" != "" ]
#then
#  echo "Error! Verification did not succeed. Review the container, script, and inputs."
#  rm -f *
#  exit 1
#fi

rm -f *
