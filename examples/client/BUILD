
load("@io_bazel_rules_go//go:def.bzl", "go_binary")

cc_binary(
    name = "client_cpp",
    srcs = ["main.cpp"],
    deps = [
        "//proto:mdining_cc_grpc",
        "@com_github_grpc_grpc//:grpc++",
    ]
)

go_binary(
    name = "client_go",
    visibility = ["//visibility:public"],
    srcs = ["main.go"],
    deps = [
        "//proto:mdining_go_proto",
        "@org_golang_google_grpc//:go_default_library",
    ]
)
