#!/bin/bash
username=$1
password=$2
InstanceIP=$3
echo "username": "$username"
echo "password": "$password"
curl -X PUT --user $username:$password  http://${InstanceIP}:5984/verifytestdb
curl -X PUT --user $username:$password http://${InstanceIP}:5984/verifytestdb_replicate
curl -X PUT -H "Content-Type: application/json" -d '{"_id":"test_doc_1","a":1}' --user $username:$password http://${InstanceIP}:5984/verifytestdb/test_doc_1
curl -X PUT -H "Content-Type: application/json" -d '{"_id":"test_doc_1","a":1,"_rev":"1-23202479633c2b380f79507a776743d5","b":"hello"}' --user $username:$password http://${InstanceIP}:5984/verifytestdb/test_doc_1
curl -X DELETE --user $username:$password http://${InstanceIP}:5984/verifytestdb/test_doc_1?rev=2-d588d3e93ee155c5afffdf0247a2c5ef
curl -X PUT -H "Content-Type: application/json" -d '{"_id":"test_doc_10","a":1}' --user $username:$password http://${InstanceIP}:5984/verifytestdb/test_doc_10
curl -X PUT -H "Content-Type: application/json" -d '{"_id":"test_doc_20","a":2}' --user $username:$password http://${InstanceIP}:5984/verifytestdb/test_doc_20
curl -X PUT -H "Content-Type: application/json" -d '{"_id":"test_doc_30","a":3}' --user $username:$password http://${InstanceIP}:5984/verifytestdb/test_doc_30
curl -X PUT -H "Content-Type: application/json" -d '{"_id":"_design/view_check","views":{"testview":{"map":"function (doc) { emit(doc._id, doc.a); }","reduce":"_sum"}}}' --user $username:$password http://${InstanceIP}:5984/verifytestdb/_design/view_check
curl --user $username:$password http://${InstanceIP}:5984/verifytestdb/_design/view_check/_view/testview
curl -X POST --user $username:$password -H "Content-Type: application/json" -d '{"create_target":true,"source":"verifytestdb","target":"verifytestdb_replicate"}'  http://${InstanceIP}:5984/_replicate
curl --user $username:$password http://${InstanceIP}:5984/verifytestdb_replicate
curl -X DELETE --user $username:$password http://${InstanceIP}:5984/verifytestdb_replicate
curl -X DELETE --user $username:$password  http://${InstanceIP}:5984/verifytestdb