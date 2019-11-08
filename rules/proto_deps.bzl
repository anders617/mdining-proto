##
# http_archive rule
##
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

##
# git_repository rule
##
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

load("//rules:maybe.bzl", "maybe")

def proto_dependencies():

    ######################
    # Protobuf Libraries #
    ######################

    ##
    # com_google_protobuf contains the protoc compiler and c++ protocol buffer runtime
    ##
    maybe(
        git_repository,
        name = "com_google_protobuf",
        commit = "6d4e7fd7966c989e38024a8ea693db83758944f1",
        remote = "https://github.com/protocolbuffers/protobuf",
        shallow_since = "1558721209 -0700"
    )

    ##
    # com_googleapis_googleapis provides common proto definitions for Google APIs
    ##
    maybe(
        git_repository,
        name = "com_googleapis_googleapis",
        commit = "fcbb13c4f84380c6546a1c78e44b241c3c8c13f4",
        remote = "https://github.com/googleapis/googleapis"
    )

    ##
    # com_google_api_codegen - Included for com_google_googleapis above 
    ##
    maybe(
        http_archive,
        name = "com_google_api_codegen",
        strip_prefix = "gapic-generator-5aa30f3d6850c8ebc1092d17ef471aea27a81242",
        urls = ["https://github.com/googleapis/gapic-generator/archive/5aa30f3d6850c8ebc1092d17ef471aea27a81242.zip"]
    )