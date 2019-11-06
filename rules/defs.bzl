# This rule was inspired by rules_closure`s implementation of
# |closure_proto_library|, licensed under Apache 2.
# https://github.com/bazelbuild/rules_closure/blob/3555e5ba61fdcc17157dd833eaf7d19b313b1bca/closure/protobuf/closure_proto_library.bzl
load("@npm_bazel_typescript//internal:common/compilation.bzl", "COMMON_ATTRIBUTES", "DEPS_ASPECTS", "compile_ts", "ts_providers_dict_to_struct")
load("@npm_bazel_typescript//internal:common/tsconfig.bzl", "create_tsconfig")
load("@build_bazel_rules_nodejs//:providers.bzl", "NpmPackageInfo", "js_ecma_script_module_info", "js_named_module_info", "node_modules_aspect")
load("@npm_bazel_typescript//internal:ts_config.bzl", "TsConfigInfo")
load("@rules_proto//proto:defs.bzl", "ProtoInfo")

##
# Heavily inspired by https://github.com/bazelbuild/rules_closure/blob/master/closure/compiler/closure_js_library.bzl
##

# This was borrowed from Rules Go, licensed under Apache 2.
# https://github.com/bazelbuild/rules_go/blob/67f44035d84a352cffb9465159e199066ecb814c/proto/compiler.bzl#L72
def _proto_path(proto):
    path = proto.path
    root = proto.root.path
    ws = proto.owner.workspace_root
    if path.startswith(root):
        path = path[len(root):]
    if path.startswith("/"):
        path = path[1:]
    if path.startswith(ws):
        path = path[len(ws):]
    if path.startswith("/"):
        path = path[1:]
    return path

def _proto_include_path(proto):
    path = proto.path[:-len(_proto_path(proto))]
    if not path:
        return "."
    if path.endswith("/"):
        path = path[:-1]
    return path

def _proto_include_paths(protos):
    return [_proto_include_path(proto) for proto in protos]

def _generate_node_grpc_web_src_progress_message(name):
    # TODO(yannic): Add a better message?
    return "Generating GRPC Web %s" % name

def _generate_node_grpc_web_srcs(
        is_grpc,
        paths,
        base_path,
        actions,
        protoc,
        protoc_gen_grpc_web,
        import_style,
        mode,
        sources,
        transitive_sources):
    all_sources = [src for src in sources] + [src for src in transitive_sources.to_list()]
    proto_include_paths = [
        "-I%s" % p
        for p in _proto_include_paths(
            [f for f in all_sources],
        )
    ]
    print(proto_include_paths)

    grpc_web_out_common_options = ",".join([
        "import_style={}".format(import_style),
        "mode={}".format(mode),
    ])

    js_out_common_options = ",".join([
        "import_style={}".format(import_style),
    ])

    files = []
    for src, path in zip(sources, paths):
        extension = ".grpc.pb.js" if is_grpc else "_pb.js"
        name = "{}{}".format(
            ".".join(src.path.split("/")[-1].split(".")[:-1]),
            extension
        )
        print(path, name)
        js = actions.declare_file("../{}/{}".format(path, name))
        bin_dir = js.path[:js.path.rfind("/{}/{}".format(path, name))] + "/" + base_path
        print(js.path)
        print(bin_dir)
        files.append(js)
        args = ["--proto_path={}".format(src.path[:-1-len(_proto_path(src))]),]
        args += proto_include_paths
        if is_grpc:
            args += [
                "--plugin=protoc-gen-grpc-web={}".format(protoc_gen_grpc_web.path),
                "--grpc-web_out={options},out={out_file}:{path}".format(
                    options = grpc_web_out_common_options,
                    out_file = name,
                    path = js.path[:js.path.rfind("/", 0, js.path.rfind("/"))] + "/" + base_path,
                ),
                src.path,
            ]
        else:
            args += [
                "--js_out={options},binary:{path}".format(
                    options=js_out_common_options,
                    path= bin_dir
                ),
                src.path,
            ]
        print(" ".join(args))
        actions.run(
            tools = [protoc_gen_grpc_web],
            inputs = all_sources,
            outputs = [js],
            executable = protoc,
            arguments = args,
            progress_message =
                _generate_node_grpc_web_src_progress_message(name),
        )

    return files

_error_multiple_deps = "".join([
    "'deps' attribute must contain exactly one label ",
    "(we didn't name it 'dep' for consistency). ",
    "We may revisit this restriction later.",
])

def _node_proto_library_impl(ctx):
    # if len(ctx.attr.deps) > 1:
    #     fail(_error_multiple_deps, "deps")

    direct_sources = []
    transitive_sources = []
    deps = []
    paths = []
    for dep in ctx.attr.deps:
        # if dep.label.package != ctx.label.package:
        #     continue
        print(dep.label.package)
        # paths.append(ctx.label.package + "/" + dep.label.package)
        direct_sources.append(dep[ProtoInfo].direct_sources)
        transitive_sources.append(dep[ProtoInfo].transitive_imports.to_list())
    #     deps.append(dep)
    #     for i in dep[ProtoInfo].transitive_imports.to_list():
    #         deps.append(_proto_path(i))
    # print(deps)
    srcs = []
    for src_list in direct_sources:
        for src in src_list:
            if src not in srcs:
                srcs.append(src)
                proto_path = _proto_path(src)
                proto_path = proto_path[:proto_path.rfind("/")]
                paths.append(ctx.label.package + "/" + proto_path)
    if not ctx.attr._is_grpc:
        for src_list in transitive_sources:
            for src in src_list:
                if src not in srcs:
                    srcs.append(src)
                    proto_path = _proto_path(src)
                    proto_path = proto_path[:proto_path.rfind("/")]
                    paths.append(ctx.label.package + "/" + proto_path)
    print(srcs)
    srcs = _generate_node_grpc_web_srcs(
        ctx.attr._is_grpc,
        paths,
        ctx.label.package,
        actions = ctx.actions,
        protoc = ctx.executable._protoc,
        protoc_gen_grpc_web = ctx.executable._protoc_gen_grpc_web,
        import_style = ctx.attr.import_style,
        mode = ctx.attr.mode,
        sources = srcs,
        transitive_sources = dep[ProtoInfo].transitive_imports,
    )

    deps = [
        ctx.attr._grpc_web_abstractclientbase,
        ctx.attr._grpc_web_clientreadablestream,
        ctx.attr._grpc_web_error,
        ctx.attr._grpc_web_grpcwebclientbase,
    ]

    # Return a structure that is compatible with the deps[] of a ts_library.
    return struct(
        files = depset(srcs),
        typescript = struct(
            declarations = depset(srcs),
            transitive_declarations = depset(srcs),
            type_blacklisted_declarations = depset(),
            es5_sources = depset(srcs),
            es6_sources = depset(srcs),
            transitive_es5_sources = depset(),
            transitive_es6_sources = depset(srcs),
        ),
    )

node_proto_library = rule(
    implementation = _node_proto_library_impl,
    attrs = dict({
        "deps": attr.label_list(
            mandatory = True,
            providers = [ProtoInfo],
        ),
        "import_style": attr.string(
            default = "commonjs",
            values = ["closure", "commonjs"],
        ),
        "mode": attr.string(
            default = "grpcwebtext",
            values = ["grpcwebtext", "grpcweb"],
        ),

        # internal only
        "_is_grpc": attr.bool(
            default = False,
        ),
        # TODO(yannic): Convert to toolchain.
        "_protoc": attr.label(
            default = Label("@com_google_protobuf//:protoc"),
            executable = True,
            cfg = "host",
        ),
        "_protoc_gen_grpc_web": attr.label(
            default = Label("@com_github_grpc_web//javascript/net/grpc/web:protoc-gen-grpc-web"),
            executable = True,
            cfg = "host",
        ),
        "_grpc_web_abstractclientbase": attr.label(
            default = Label("@com_github_grpc_web//javascript/net/grpc/web:abstractclientbase"),
        ),
        "_grpc_web_clientreadablestream": attr.label(
            default = Label("@com_github_grpc_web//javascript/net/grpc/web:clientreadablestream"),
        ),
        "_grpc_web_error": attr.label(
            default = Label("@com_github_grpc_web//javascript/net/grpc/web:error"),
        ),
        "_grpc_web_grpcwebclientbase": attr.label(
            default = Label("@com_github_grpc_web//javascript/net/grpc/web:grpcwebclientbase"),
        ),
    })
)

node_grpc_web_proto_library = rule(
    implementation = _node_proto_library_impl,
    attrs = dict({
        "deps": attr.label_list(
            mandatory = True,
            providers = [ProtoInfo],
        ),
        "import_style": attr.string(
            default = "commonjs",
            values = ["closure", "commonjs"],
        ),
        "mode": attr.string(
            default = "grpcwebtext",
            values = ["grpcwebtext", "grpcweb"],
        ),

        # internal only
        # TODO(yannic): Convert to toolchain.
        "_is_grpc": attr.bool(
            default = True,
        ),
        "_protoc": attr.label(
            default = Label("@com_google_protobuf//:protoc"),
            executable = True,
            cfg = "host",
        ),
        "_protoc_gen_grpc_web": attr.label(
            default = Label("@com_github_grpc_web//javascript/net/grpc/web:protoc-gen-grpc-web"),
            executable = True,
            cfg = "host",
        ),
        "_grpc_web_abstractclientbase": attr.label(
            default = Label("@com_github_grpc_web//javascript/net/grpc/web:abstractclientbase"),
        ),
        "_grpc_web_clientreadablestream": attr.label(
            default = Label("@com_github_grpc_web//javascript/net/grpc/web:clientreadablestream"),
        ),
        "_grpc_web_error": attr.label(
            default = Label("@com_github_grpc_web//javascript/net/grpc/web:error"),
        ),
        "_grpc_web_grpcwebclientbase": attr.label(
            default = Label("@com_github_grpc_web//javascript/net/grpc/web:grpcwebclientbase"),
        ),
    })
)