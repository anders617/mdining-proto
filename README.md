# mdining-proto

[![Build Status](https://travis-ci.org/anders617/mdining-proto.svg?branch=master)](https://travis-ci.org/anders617/mdining-proto)

Proto definitions for use with the [michigan-dining-api](https://github.com/anders617/michigan-dining-api) service

The file [mdining.proto](https://github.com/anders617/mdining-proto/blob/master/proto/mdining.proto) defines the grpc service for michigan-dining-api and is the most important file for clients to use.

The remaining files define the proto messages used by the service

## Language Support
**[Bazel](#Bazel)** \
**[Go](#Go)** \
**[Javascript/Node.js](#Javascript/Node.js)**
### Bazel
Add the following to your WORKSPACE file:
```python
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
git_repository(
    name = "com_github_anders617_mdining_proto",
    commit = "341cec62cda03b3341648f179d779eacaf93d904",
    remote = "github.com/anders617/mdining-proto"
)
```
### Go
Go is supported through Bazel.
You can reference the `//proto:mdining_go_proto` target like so:
```python
go_library(
    name = "my_library",
    srcs = [
        "my_source.go"
    ],
    importpath = "github.com/my/import/path",
    deps = [
        "@com_github_anders617_mdining_proto//proto:mdining_go_proto",
    ],
)
```

In your Go code:
```go
package main

import (
    "context"
    "fmt"

    pb "github.com/anders617/mdining-proto/proto/mdining"
    "google.golang.org/grpc"
)

func main() {
    address := "michigan-dining-api.herokuapp.com:80"
    fmt.Printf("Connecting to %s...", address)
    conn, err := grpc.Dial(address, grpc.WithInsecure(), grpc.WithBlock())
    if err != nil {
        fmt.Printf("Could not dial %s: %s", address, err)
        return
    }
    defer conn.Close()
    fmt.Printf("Connected")

    // Create the MDiningClient
    client := pb.NewMDiningClient(conn)

    // Send a GetDiningHalls request
    diningHallsReply, err := client.GetDiningHalls(context.Background(), &pb.DiningHallsRequest{})

    if err != nil {
        fmt.Printf("Could not call GetDiningHalls: %s", err)
        return
    }
    fmt.Printf("DiningHallsReply: %v\n", diningHallsReply)
}
```
### Javscript/Node.js
Download the [npm package](https://www.npmjs.com/package/mdining-proto) using [npm](https://www.npmjs.com/get-npm):
```shell
npm install mdining-proto
```
or [yarn](https://yarnpkg.com/en/docs/install#mac-stable):
```shell
yarn add mdining-proto
```
Then in your code you can import the proto types and client like so:
```javascript
import { MDiningPromiseClient, DiningHallsRequest } from 'mdining-proto';

const client = new MDiningPromiseClient('https://michigan-dining-api.herokuapp.com');

client.getDiningHalls(new DiningHallsRequest())
    .then((diningHalls) => console.log(diningHalls))
    .catch((err) => console.log(err));
```
