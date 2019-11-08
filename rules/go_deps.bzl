load("@bazel_gazelle//:deps.bzl", "go_repository")
load("//rules:maybe.bzl", "maybe")

def go_dependencies():
    ################
    # Go Libraries #
    ################

    ##
    # org_golang_google_grpc - Go grpc runtime library
    ##
    maybe(
        go_repository,
        name = "org_golang_google_grpc",
        build_file_proto_mode = "disable",
        importpath = "google.golang.org/grpc",
        sum = "h1:vb/1TCsVn3DcJlQ0Gs1yB1pKI6Do2/QNwxdKqmc/b0s=",
        version = "v1.24.0"
    )

    ##
    #  grpc_ecosystem_grpc_gateway - grpc gateway runtime library
    ##
    maybe(
        go_repository,
        name = "grpc_ecosystem_grpc_gateway",
        importpath = "github.com/grpc-ecosystem/grpc-gateway",
        sum = "h1:h8+NsYENhxNTuq+dobk3+ODoJtwY4Fu0WQXsxJfL8aM=",
        version = "v1.11.3"
    )

