# Dockerfile for minimal ffmpeg based on alpine
FROM alpine:3.4 as build

MAINTAINER Fred Park <https://github.com/alfpark/docker-ffmpeg>

# build ffmpeg
RUN apk add --update --no-cache \
        build-base \
        ca-certificates \
        coreutils \
        curl \
        freetype-dev \
        lame-dev \
        libass-dev \
        libogg-dev \
        libtheora-dev \
        libvorbis-dev \
        libvpx-dev \
        libwebp-dev \
        musl \
        nasm \
        openssl-dev \
        opus-dev \
        rtmpdump-dev \
        tar \
        x264-dev \
        x265-dev \
        xvidcore-dev \
        yasm-dev \
        zlib-dev \
    && FFMPEG_VER=3.2.1 \
    && curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VER}.tar.gz | tar zxvf - -C . \
    && cd ffmpeg-${FFMPEG_VER} \
    && ./configure \
        --disable-debug --enable-version3 --enable-small --enable-gpl \
        --enable-nonfree --enable-postproc --enable-openssl \
        --enable-avresample --enable-libfreetype --enable-libmp3lame \
        --enable-libx264 --enable-libx265 --enable-libopus --enable-libass \
        --enable-libwebp --enable-librtmp --enable-libtheora \
        --enable-libvorbis --enable-libvpx --enable-libxvid \
    && make -j"$(nproc)" install

# install ffmpeg and runtime dependencies
FROM alpine:3.4

COPY --from=build /usr/local/bin/ffmpeg /usr/local/bin/

RUN apk add --update --no-cache \
        ca-certificates \
        faac \
        freetype \
        lame \
        libass \
        libogg \
        libtheora \
        libvorbis \
        libvpx \
        libwebp \
        musl \
        opus \
        rtmpdump-dev \
        x264-dev \
        x265-dev \
        xvidcore \
        zlib

ENTRYPOINT ["ffmpeg"]
