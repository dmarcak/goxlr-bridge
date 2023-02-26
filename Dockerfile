FROM dart:stable as build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub get --offline
RUN dart compile exe bin/goxlr_bridge.dart -o bin/goxlr_bridge

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/goxlr_bridge /app/bin/

EXPOSE 6805

ENTRYPOINT [ "/app/bin/goxlr_bridge" ]
CMD [ "-h 0.0.0.0" ]
