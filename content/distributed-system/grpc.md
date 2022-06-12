---
title: "gRPC"
date: "2022-06-12"
tags: [distributed system, grpc]
layout: slide
draft: true
---

## gRPC

A high performance, open source universal RPC framework

---

## Why gRPC?

gRPC is a modern open source high performance Remote Procedure Call(RPC) framework that can run in any environment. It can effciently connect services in and across data centers with pluggable support for load balancing, tracing, health checking and authentication. It is als applicable in last mile of distributed computing to connect devices, mobile applications and browsers to backend services.

---

## Why gRPC?

- Simple service definition
- Start quickly and scale
- Works across languages and platforms
- Bi-directional streaming and integrated auth

---

### Simple service definition

Define your service using Protocol Buffers, a powerful binary serialization toolset and language

---

### Start quickly and scale

Install runtime and dev environments with a single line and also scale to millions of RPCs per second with the framework

---

### Works across languages and platforms

Automatically generate idiomatic client and server stubs for your service in a variety of languages and platforms

---

### Bi-directional streaming and integrated auth

Bi-directional streaming and fully integrated pluggable authentication with HTTP/2-based transport

---

## Core concepts, architecture and lifecycle

---

## Overview

---

### Service definition

Like many RPC systems, gRPC is based the idea of defining a service, specifyung the methods that can be called remotely with therir parameters and return types.
By default, gRPC uses protocol buffers as the Interface Definition Language (IDL) for describing both the service interface and the structure of the payload messages.
It is possible to use other alternatives if desired.

```proto
service HelloService {
  rpc SayHello (HelloRequest) returns (HelloResponse);
}

message HelloRequest {
  string greeting = 1;
}

message HelloResponse {
  string reply = 1;
}
```

---

gRPC let you define four kinds of service method:

---

- Unary RPCs where the client sends a single request to the server and gets a single response back, just like a normal function call.

```proto
rpc SayHello(HelloRequest) returns (HelloResponse);
```

---

- Server streaming RPCs where the client sends a request to the server and gets a strem to read a sequence of messages back.
The client reads from the returned stream until there are no more messages. gRPC guarantees message ordering within an individual RPC call.

```proto
rep LotsOfReplies(HelloRequest) returns (stream HelloResponse);
```

---

- Client streaming RPCs where the client writes a sequence of messages and sends them to the server, again  using a provided stream.
Once the client has finished writing the messages, it waits for the server to read them and return its reponse. Again gRPC guarantees message ordering within an individual RPC call.

```proto
rpc LotsOfGreetings(stream HelloRequest) returns (HelloResponse);
```

---

- Bidirectional streaming RPCs where both sides send a sequence of messages using a read-write stream.
The two streams operate independently, so clients and servers can read and write in whatever order they like:
for example, the server could wait to receive all the client messages before writing its responses, or it could alternately read a message ten write a message, or some other combination of reads and writes.
The order of messages in each stream is preserved.

```proto
rpc BidiHello(stream HelloRequest) returns (stream HelloResponse);
```

---

### Using the API

Starting from a service definition in a `.proto` file, gRPC provides protocol buffer compiler plugins that generate client- and server-side code.
gRPC users typically call these APIs of the client side and implent the corresponding API on the server side.

- On the server side, the server implements the methods declared by the service and runs a gRPC server to handle client calls.
The gRPC infrastructure decodes incoming requests, executes service methods, and encodes service responses.

- On the client side, the client has a local object known as stuc(for some languages, the preferred term is client) that implements the same methods as the service.
The client can then just call those methods on the local obejct, wrapping the parameters for the call in the appropriate protocol buffer message type - gRPC looks after sending the request(s) to the server and returning the server's protocol buffer response(s).

---

### Synchronous vs. asynchronous

Synchronous RPC calls that block until a response arrives from the server are the closest approximation to the abstraction of a procedure call that RPC aspires to.
On the other hand, networks are inherently asynchronous and in many scenarios it's useful to be able to start RPCs without blocking the current thread.

The gRPC programming API in most languages comes in both synchronous and asynchronous flavors.
You can find out more in each language's tutorial and reference documentation (complete reference docs are coming soon).

---

## RPC life cycle

---

### Unary RPC

1. Once the client calls a stub method, the server is notified that the RPC has been invoked with the client's metadata for this call, the method name, and the specified deadline if applicable.
2. The server can then either send back its own initial metadata(which must be sent before any response) straight away, or wait for the client's request message.
Which happens first, is application-specific.
3. Once the server has the client's request message, it does whatever work is necessary to create and populate response.
The response is then returned (if successful) to the client together with the status details (status code and optional status message) and optional trailing metadata.
4. If the response status is OK, then the client gets the response, which completes the call on the client side.

---

### Server streaming RPC

A server-streaming RPC is similar to a unary RPC, except that the server returns a stream of messages in response to client's request.
After sending all its messages, the server's status details (status code and optional status message) and optional trailing metadata are sent ot the client.
This completes processing on the server side. The client completes it ha all the server's messaged.




---

## References

- https://grpc.io/
- https://github.com/hueypark/grpc-tutorial