load("@io_bazel_rules_go//go:def.bzl", "go_binary")

cc_binary(
    name = "server_cpp",
    srcs = ["main.cpp"],
    deps = [
        "//proto:mdining_cc_grpc",
        "@com_github_grpc_grpc//:grpc++",
    ],
    data = [
        "//proto/sample:proto_sample_data",
    ]
)


go_binary(
    name = "server_go",
    visibility = ["//visibility:public"],
    srcs = ["main.go"],
    deps = [
        "//proto:mdining_go_proto",
        "@com_github_golang_protobuf//proto:go_default_library",
        "@org_golang_google_grpc//:go_default_library",
        "@org_golang_google_grpc//status:go_default_library",
        "@org_golang_google_grpc//codes:go_default_library",
    ],
    data = [
        "//proto/sample:proto_sample_data",
    ]
)