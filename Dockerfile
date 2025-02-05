FROM rust:1.73-alpine3.17

LABEL "name"="Automate publishing Rust build artifacts for GitHub releases through GitHub Actions"
LABEL "version"="1.4.4"
LABEL "repository"="http://github.com/rust-build/rust-build.action"
LABEL "maintainer"="Douile <25043847+Douile@users.noreply.github.com>"

# Add regular dependencies
RUN apk add --no-cache curl jq git build-base bash zip tar xz zstd upx python3

# Add windows dependencies
RUN apk add --no-cache mingw-w64-gcc

# Linux aarch64
RUN git clone https://github.com/lovell/aarch64-linux-musl-crosstools.git /opt/aarch64-linux-musl-crosstools
RUN mv /opt/aarch64-linux-musl-crosstools/aarch64-linux-musl-cross /opt/aarch64-musl-cross

# Add apple dependencies
RUN apk add --no-cache clang cmake libxml2-dev openssl-dev musl-fts-dev bsd-compat-headers
RUN git clone https://github.com/tpoechtrager/osxcross /opt/osxcross
RUN curl -Lo /opt/osxcross/tarballs/MacOSX11.3.sdk.tar.xz "https://storage.googleapis.com/ory.sh/build-assets/MacOSX11.3.sdk.tar.xz"
RUN ["/bin/bash", "-c", "cd /opt/osxcross && UNATTENDED=yes OSX_VERSION_MIN=11.3 ./build.sh"]

COPY entrypoint.sh /entrypoint.sh
COPY build.sh /build.sh
COPY common.sh /common.sh

RUN chmod 555 /entrypoint.sh /build.sh /common.sh

ENTRYPOINT ["/entrypoint.sh"]
