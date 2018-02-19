# aws-cloudfront-keypair-docker
Docker container for generating Cloudfront keypair contents and securely
uploading and storing in AWS System Manager Parameter Store per each region
listed.

Steps (preferred)
1. Clone this repo
2. Set up an AWS profile with keys with sufficient access
3. Customize regions list to needs
4. Run localRun.sh to build the container and kick off the generation
5. When asked for the SSM parameter name, copy the public key output (including
   the header/footer into a new file. Call it whatever you want, but give it a
   PEM extension)
6. Upload the PEM file into the Cloudfront Key Pairs section in Security
   Credentials and copy the generated access key id
7. Paste the access key id in at the prompt for the SSM parameter name
8. Per specified region, look for a JSON output stating a version number

Steps (alternate)
1. Pull the image down from https://hub.docker.com/r/zippadd/aws-cloudfront-keypair-docker/
2. Start at step 4 from above. You will be prompted for the region list.
