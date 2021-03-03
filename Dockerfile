FROM alpine:3.13.2 AS build

RUN apk update && apk add build-base gcc perl libtool linux-headers curl cmake automake m4 libtool intltool autoconf

COPY . /build
WORKDIR /build

RUN make

FROM alpine:3.13.2

RUN apk update && apk add libstdc++ libgcc

RUN mkdir /rocks
WORKDIR /rocks
COPY --from=build /build/rocksdb-server ./rocksdb-server

EXPOSE 6379

CMD ["./rocksdb-server", "-p", "6379", "-d", "/data"]