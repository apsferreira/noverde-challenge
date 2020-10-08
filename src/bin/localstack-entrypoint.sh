#!/usr/bin/env bash

localhost='http://localhost:4566'
api_name='loan'

echo '
     ##############################################################
     #######            Configuring localstack S3         #########
     ##############################################################
     '

aws --endpoint-url=$localhost s3 mb s3://frontend

aws --endpoint-url=$localhost s3 website s3://frontend --index-document index.html --error-document error.html

aws --endpoint-url=$localhost s3 cp ./frontend/ s3://frontend/  --acl public-read --recursive

aws --endpoint-url=$localhost s3 create-bucket --bucket http-lambdas-deploy

aws --endpoint-url=$localhost s3 put-bucket-acl --bucket http-lambdas-deploy --acl public-read

echo '
     ##############################################################
     #######      Configuring localstack Dynamodb         #########
     ##############################################################
     '

# Table client
aws --endpoint-url=$localhost dynamodb create-table --table-name client  \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5   

# Table loan
aws --endpoint-url=$localhost dynamodb create-table --table-name loan  \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5   

echo '
     ##############################################################
     #######      Configuring Serverless Lambda           #########
     ##############################################################
     '
npm install --save serverless-localstack
serverless deploy

