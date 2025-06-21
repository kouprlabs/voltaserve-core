# Voltaserve Core

This is a Swift package that consists of the core building blocks for the iOS, iPadOS and macOS apps, it contains client to invoke Voltaserve REST APIs, and other reusable views and extensions.

## Getting Started

Prerequisites:

- Install [Xcode](https://developer.apple.com/xcode/).
- Install [SwiftLint](https://github.com/realm/SwiftLint).

The clients in [Sources/Clients](./Sources/Clients) can be used to communicate with Voltaserve APIs.

Format code:

```shell
swift format -i -r .
```

Lint code:

```shell
swift format lint -r .
```

```shell
swiftlint lint --strict .
```

## Tests

The test suite expects the following accounts to exist:

| Email            | Password    |
| ---------------- | ----------- |
| test@koupr.com   | `Passw0rd!` |
| test+1@koupr.com | `Passw0rd!` |

Build and run with Docker:

```shell
docker build -t voltaserve/swift-tests . && docker run --rm \
    -e API_HOST=host.docker.internal \
    -e IDP_HOST=host.docker.internal \
    -e USERNAME='test@koupr.com' \
    -e PASSWORD='Passw0rd!' \
    -e OTHER_USERNAME='test+1@koupr.com' \
    -e OTHER_PASSWORD='Passw0rd!' \
    voltaserve/swift-tests
```

In Linux you should replace `host.docker.internal` with the host IP address, it can be found as follows:

```shell
ip route | grep default | awk '{print $3}'
```

## Licensing

Voltaserve Core is released under the [Business Source License 1.1](LICENSE).
