FROM btwiuse/arch:golang as portmux

RUN GOBIN=/usr/local/bin/ go install -v github.com/btwiuse/portmux@v0.0.1

FROM btwiuse/arch:rustup as builder

COPY . /build

WORKDIR /build

RUN cargo build --release

FROM btwiuse/arch:deno

WORKDIR /data

COPY --from=builder /build/target/release/nftmart-node /usr/bin/nftmart-node

RUN chmod +x /usr/bin/nftmart-node

COPY --from=builder /build/target/release/nftmart-aura-node /usr/bin/nftmart-aura-node

RUN chmod +x /usr/bin/nftmart-aura-node

COPY scripts/rotate-key /usr/bin/rotate-key

RUN chmod +x /usr/bin/rotate-key

EXPOSE 30333

RUN ln -sf nftmart-node /usr/bin/nftmart

COPY --from=portmux /usr/local/bin/portmux /usr/bin/portmux

ENV PORTMUX_HTTP 127.0.0.1:9933
ENV PORTMUX_WS 127.0.0.1:9944
ENV PORTMUX_UI https://redirect.subshell.xyz

ENTRYPOINT ["nftmart-node"]
