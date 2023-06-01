FROM quay.io/projectquay/golang:1.20 as builder

WORKDIR /go/src/app
COPY . .
ARG TARGETOS
ARG TARGETARCH
RUN make build TARGETOS=$TARGETOS TARGETARCH=$TARGETARCH

# Save certificates
RUN cp /etc/ssl/certs/ca-certificates.crt /go/src/app/

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=builder /go/src/app/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./kbot", "start"]

