#Generate salt
salt=`openssl rand -base64 16`

#Encrypt
encryptedPKCS8Key=`aws kms encrypt --key-id $keyId --plaintext fileb://cloudfront_key_sanshf_bPKCS8.pem --encryption-context salt=$salt --query CiphertextBlob | sed '$ s/.$//; s/^.//'`

#Verify decrypt
echo "$encryptedPKCS8Key" | base64 -d > cloudfront_key_decrypted_bPKCS8.pem
decryptedPKCS8Key=`aws kms decrypt --ciphertext-blob fileb://cloudfront_key_decrypted_bPKCS8.pem --encryption-context salt=$salt --output text | cut -f2` # | openssl pkcs8 -nocrypt | openssl rsa -pubout
printf "-----BEGIN PRIVATE KEY-----\n%s\n-----END PRIVATE KEY-----" "$decryptedPKCS8Key" > cloudfront_key_decrypted_PKCS8.pem
openssl pkcs8 -nocrypt -in cloudfront_key_decrypted_PKCS8.pem -out cloudfront_key_decrypted.pem
openssl rsa -in cloudfront_key_decrypted.pem -out cloudfront_key_decrypted.pub -pubout
verifyPublicKey=`cat cloudfront_key_decrypted.pub`

if [ "$publicKey" != "$verifyPublicKey" ]
then
  echo "Error! Verification did not succeed. Review the container, script, and inputs."
  rm -f *
  exit 1
else
  echo "Success! Cloudfront pair information below."
fi

echo ""
echo "KMS Encryption Salt (e.g. for lambda env variable):"
echo "$salt"
echo ""
echo "KMS Encrypted Private Key (PKCS8 format, no header/footer; e.g. for lambda)":
echo "$encryptedPKCS8Key"
