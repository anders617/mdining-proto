cc_binary(
    name = "cc_server",
    srcs = ["main.cpp"],
    deps = [
        "//proto:mdining_cc_grpc",
        "@com_github_grpc_grpc//:grpc++",
    ],
    data = [
        "//proto/sample:proto_sample_data",
    ]
)