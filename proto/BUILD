load("@rules_proto//proto:defs.bzl", "proto_library")
load("@io_bazel_rules_go//proto:def.bzl", "go_proto_library")
load("//rules:defs.bzl", "node_grpc_web_proto_library", "node_proto_library")
load("@build_bazel_rules_nodejs//:defs.bzl", "nodejs_binary")
load("@com_github_grpc_grpc//bazel:cc_grpc_library.bzl", "cc_grpc_library")
# load("@cc_rules//defs.bzl", "cc_proto_library", "cc_library")

#########
# Proto #
#########

proto_library(
    name = "dininghalls_proto",
    srcs = ["dininghalls.proto"],
    visibility = ["//visibility:public"],
)

proto_library(
    name = "items_proto",
    srcs = ["items.proto"],
    visibility = ["//visibility:public"],
    deps = [
        ":food_proto",
    ]
)

proto_library(
    name = "filterable_entries_proto",
    srcs = ["filterableentries.proto"],
    visibility = ["//visibility:public"],
)

proto_library(
    name = "menu_proto",
    srcs = ["menu.proto"],
    visibility = ["//visibility:public"],
)

proto_library(
    name = "food_proto",
    srcs = ["food.proto"],
    visibility = ["//visibility:public"],
    deps = [
        ":menu_proto"
    ]
)

proto_library(
    name = "foodstat_proto",
    srcs = ["foodstat.proto"],
    visibility = ["//visibility:public"],
)

proto_library(
    name = "mdining_proto",
    srcs = ["mdining.proto"],
    visibility = ["//visibility:public"],
    deps = [
        ":dininghalls_proto",
        ":filterable_entries_proto",
        ":items_proto",
        ":menu_proto",
        ":food_proto",
        ":foodstat_proto",
        "@com_googleapis_googleapis//google/api:annotations_proto",
    ],
)

proto_library(
    name = "mdiningapi_proto",
    srcs = ["mdiningapi.proto"],
    visibility = ["//visibility:public"],
    deps = [
        ":dininghalls_proto",
        ":filterable_entries_proto",
        ":items_proto",
        ":menu_proto",
        ":food_proto",
    ],
)

##########
# Golang #
##########

go_proto_library(
    name = "mdiningapi_go_proto",
    compilers = [
        "@io_bazel_rules_go//proto:go_grpc",
        "@grpc_ecosystem_grpc_gateway//protoc-gen-grpc-gateway:go_gen_grpc_gateway",
    ],
    importpath = "github.com/anders617/mdining-proto/proto/mdiningapi",
    protos = [
        ":mdiningapi_proto",
    ],
    visibility = ["//visibility:public"],
    deps = [
        ":mdining_go_proto",
        "@com_github_golang_protobuf//descriptor:go_default_library",
        "@com_github_golang_protobuf//proto:go_default_library",
        "@grpc_ecosystem_grpc_gateway//runtime:go_default_library",
        "@grpc_ecosystem_grpc_gateway//utilities:go_default_library",
        "@org_golang_google_genproto//googleapis/api/annotations:go_default_library",
        "@org_golang_google_grpc//:go_default_library",
        "@org_golang_google_grpc//codes:go_default_library",
        "@org_golang_google_grpc//grpclog:go_default_library",
        "@org_golang_google_grpc//status:go_default_library",
    ],
)

go_proto_library(
    name = "mdining_go_proto",
    compilers = [
        "@io_bazel_rules_go//proto:go_grpc",
        "@grpc_ecosystem_grpc_gateway//protoc-gen-grpc-gateway:go_gen_grpc_gateway",
    ],
    importpath = "github.com/anders617/mdining-proto/proto/mdining",
    protos = [
        ":dininghalls_proto",
        ":filterable_entries_proto",
        ":items_proto",
        ":mdining_proto",
        ":menu_proto",
        ":food_proto",
        ":foodstat_proto",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_golang_protobuf//descriptor:go_default_library",
        "@com_github_golang_protobuf//proto:go_default_library",
        "@grpc_ecosystem_grpc_gateway//runtime:go_default_library",
        "@grpc_ecosystem_grpc_gateway//utilities:go_default_library",
        "@org_golang_google_genproto//googleapis/api/annotations:go_default_library",
        "@org_golang_google_grpc//:go_default_library",
        "@org_golang_google_grpc//codes:go_default_library",
        "@org_golang_google_grpc//grpclog:go_default_library",
        "@org_golang_google_grpc//status:go_default_library",
    ],
)

######################
# Javascript/Node.js #
######################

node_grpc_web_proto_library(
    name = "mdining_grpcweb_proto",
    deps = [
        ":mdining_proto",
    ],
    mode = "grpcweb",
)

node_proto_library(
    name = "mdining_node_proto",
    tags = ["no-cache"],
    deps = [
        ":dininghalls_proto",
        ":filterable_entries_proto",
        ":items_proto",
        ":menu_proto",
        ":food_proto",
        ":mdining_proto",
        ":foodstat_proto",
    ],
)

nodejs_binary(
    name = "mdining_ts_proto",
    visibility = ["//visibility:public"],
    data = [
        ":mdining_node_proto",
        ":mdining_grpcweb_proto",
        "index.js",
    ],
    entry_point = ":index.js",
)


#######
# C++ #
#######

cc_proto_library(
    name = "dininghalls_cc_proto",
    visibility = ["//visibility:public"],
    deps = [":dininghalls_proto"]
)

cc_proto_library(
    name = "filterable_entries_cc_proto",
    visibility = ["//visibility:public"],
    deps = [":filterable_entries_proto"],
)

cc_proto_library(
    name = "items_cc_proto",
    visibility = ["//visibility:public"],
    deps = [":items_proto"],
)

cc_proto_library(
    name = "mdining_cc_proto",
    visibility = ["//visibility:public"],
    deps = [":mdining_proto"],
)

cc_grpc_library(
    name = "mdining_cc_grpc",
    visibility = ["//visibility:public"],
    srcs = [":mdining_proto"],
    grpc_only = True,
    deps = [":mdining_cc_proto"],
)

cc_proto_library(
    name = "menu_cc_proto",
    visibility = ["//visibility:public"],
    deps = [":menu_proto"],
)

cc_proto_library(
    name = "food_cc_proto",
    visibility = ["//visibility:public"],
    deps = [":food_proto"],
)

cc_proto_library(
    name = "foodstat_cc_proto",
    visibility = ["//visibility:public"],
    deps = [":foodstat_proto"],
)

cc_library(
    name = "mdining_cc_library",
    visibility = ["//visibility:public"],
    deps = [
        ":dininghalls_cc_proto",
        ":filterable_entries_cc_proto",
        ":items_cc_proto",
        ":mdining_cc_proto",
        ":menu_cc_proto",
        ":food_cc_proto",
        ":foodstat_cc_proto",
    ]
)
