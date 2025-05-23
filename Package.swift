// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "whisper",
    platforms: [
        .macOS(.v12),
        .iOS(.v14),
        .watchOS(.v4),
        .tvOS(.v14)
    ],
    products: [
        .library(name: "whisper", targets: ["whisper"]),
    ],
    targets: [
        .target(
            name: "whisper",
            path: ".",
            exclude: [
               "bindings",
               "cmake",
               "coreml",
               "examples",
               "extra",
               "models",
               "samples",
               "tests",
               "CMakeLists.txt",
               "ggml-cuda.cu",
               "ggml-cuda.h",
               "Makefile"
            ],
            sources: [
                "ggml.c",
                "whisper.cpp",
                "ggml-alloc.c",
                "ggml-backend.c",
                "ggml-quants.c",
                "ggml-metal.m"
            ],
            resources: [.process("ggml-metal.metal")],
            publicHeadersPath: "spm-headers",
            cSettings: [
                // Remova o -O3 e -DNDEBUG para deixar o Xcode controlar otimização
                // .unsafeFlags(["-Wno-shorten-64-to-32"]), // mantenha se necessário
                
                .define("GGML_USE_ACCELERATE"),
                // Se o -fno-objc-arc for necessário para os arquivos .m (ggml-metal.m), pode ser obrigatório manter:
                .unsafeFlags(["-fno-objc-arc"]),
                .define("GGML_USE_METAL")
            ],

            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        )
    ],
    cxxLanguageStandard: .cxx11
)
