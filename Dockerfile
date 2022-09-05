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

ENTRYPOINT ["nftmart-node"]
