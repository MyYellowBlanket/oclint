FROM ubuntu:18.04

# RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y \
    wget software-properties-common git \
    python \
    cmake build-essential ninja-build && \
    rm -rf /var/lib/apt/lists/*

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository "deb https://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main" && \
    apt-get update && \
    apt-get install -y clang-8 libclang-8-dev libz-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/oclint/oclint-json-compilation-database.git

COPY . /oclint

RUN mv /oclint-json-compilation-database /oclint/ && \
    cd /oclint/oclint-scripts && \
    ./makeWithSystemLLVM /usr/lib/llvm-8 && \
    cp -r /oclint/build/oclint-release/* /usr/local/

VOLUME ["/app"]

WORKDIR /app

ENTRYPOINT ["oclint"]
