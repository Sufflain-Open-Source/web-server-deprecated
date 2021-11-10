FROM ubuntu as build

RUN apt update && \
    apt-get install -y apt-transport-https wget gnupg2 && \
    sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list' && \
    apt update && apt install -y dart make

RUN dart pub global activate webdev

WORKDIR /app
COPY . .

RUN dart pub get && make build/sflw

FROM ubuntu

COPY --from=build /app/build /build
COPY --from=build /app/web /web

EXPOSE 80

ENTRYPOINT [ "/build/sflw" , "-a0.0.0.0"]
