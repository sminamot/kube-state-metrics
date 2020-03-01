ARG GO_VERSION
ARG PKG
ARG TAG
ARG Commit
ARG BuildDate

FROM golang:${GO_VERSION} as builder

WORKDIR /app

COPY . .
RUN CGO_ENABLED=0 go build -ldflags "-s -w -X ${PKG}/version.Release=${TAG} -X ${PKG}/version.Commit=${Commit} -X ${PKG}/version.BuildDate=${BuildDate}" -o kube-state-metrics

FROM gcr.io/distroless/static

COPY --from=builder /app/kube-state-metrics /

USER nobody

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081
