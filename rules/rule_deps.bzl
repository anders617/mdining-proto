##
# http_archive rule
##
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

##
# git_repository rule
##
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

load("//rules:maybe.bzl", "maybe")

def rule_dependencies():
    ###############
    # BUILD RULES #
    ###############

    ##
    # rules_proto provides rules for building protocol buffer files
    ##
    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "602e7161d9195e50246177e7c55b2f39950a9cf7366f74ed5f22fd45750cd208",
        strip_prefix = "rules_proto-97d8af4dc474595af3900dd85cb3a29ad28cc313",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
            "https://github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
        ]
    )

    ##
    # io_bazel_rules_go provides rules for buidling go libraries and executables
    ##
    maybe(
        http_archive,
        name = "io_bazel_rules_go",
        urls = [
            "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/rules_go/releases/download/v0.20.2/rules_go-v0.20.2.tar.gz",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.20.2/rules_go-v0.20.2.tar.gz"
        ],
        sha256 = "b9aa86ec08a292b97ec4591cf578e020b35f98e12173bbd4a921f84f583aebd9"
    )

    ##
    # io_bazel_rules_closure - Included for com_github_grpc_web
    ##
    maybe(
        http_archive,
        name = "io_bazel_rules_closure",
        sha256 = "fecda06179906857ac79af6500124bf03fe1630fd1b3d4dcf6c65346b9c0725d",
        strip_prefix = "rules_closure-03110588392d8c6c05b99c08a6f1c2121604ca27",
        urls = [
            "https://github.com/bazelbuild/rules_closure/archive/03110588392d8c6c05b99c08a6f1c2121604ca27.zip",
        ]
    )

    ##
    # build_stack_rules_proto - Included for grpc gateway bazel rules for protos
    ##
    maybe(
        http_archive,
        name = "build_stack_rules_proto",
        sha256 = "c62f0b442e82a6152fcd5b1c0b7c4028233a9e314078952b6b04253421d56d61",
        strip_prefix = "rules_proto-b93b544f851fdcd3fc5c3d47aee3b7ca158a8841",
        urls = ["https://github.com/stackb/rules_proto/archive/b93b544f851fdcd3fc5c3d47aee3b7ca158a8841.tar.gz"]
    )

    ##
    # com_github_grpc_web - Included for generated grpc web proto files
    ##
    maybe(
        git_repository,
        name = "com_github_grpc_web",
        commit = "8b501a96f427603ee600d3ff0291eff932fb54a1",
        remote = "https://github.com/grpc/grpc-web"
    )

    ##
    # build_bazel_rules_nodejs - Included for generating nodejs 
    ##
    maybe(
        http_archive,
        name = "build_bazel_rules_nodejs",
        sha256 = "3d7296d834208792fa3b2ded8ec04e75068e3de172fae79db217615bd75a6ff7",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.39.1/rules_nodejs-0.39.1.tar.gz"]
    )

    ##
    # bazel_gazelle for easily updating go dependency rules
    ##
    maybe(
        http_archive,
        name = "bazel_gazelle",
        sha256 = "7fc87f4170011201b1690326e8c16c5d802836e3a0d617d8f75c3af2b23180c4",
        urls = [
            "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/bazel-gazelle/releases/download/0.18.2/bazel-gazelle-0.18.2.tar.gz",
            "https://github.com/bazelbuild/bazel-gazelle/releases/download/0.18.2/bazel-gazelle-0.18.2.tar.gz",
        ],
    )
