const grpc = require('grpc');
const path = require('path');
var protoLoader = require('@grpc/proto-loader');

const PROTO_PATH = path.join('./pkg/service/hello.proto');


const protoDef = protoLoader.loadSync(PROTO_PATH);
const proto = grpc.loadPackageDefinition(protoDef);
const greeterService = proto.service.Greeter;
const client = new greeterService('localhost:8080', grpc.credentials.createInsecure());

client.SayHello({name: 'yolo'}, (err, resp) => {
    console.log(`Response ${resp.message}`);
})
