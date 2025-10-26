# Docker usage for this Flutter project

This repository includes a small Docker setup for building or running Flutter tooling without installing Flutter locally.

What was added

- `Dockerfile` - base container image using `cirrusci/flutter:stable`. Provides the Flutter SDK and basic tools.
- `docker-compose.yml` - convenience service to run the container with the project mounted.
- `.dockerignore` - keeps build artifacts and caches out of the image context.

Quick start

1. Build the image:

   docker compose build

2. Start an interactive container (project mounted):

   docker compose run --rm flutter

   This drops you into `/workspace` where you can run `flutter` commands like `flutter pub get`, `flutter run -d web-server`, `flutter build web`, etc.

Build web (example)

From inside the container:

  flutter build web --release

The built artifacts will be in `build/web` on your host (because the project is mounted into the container).

Build Android (notes)

Building Android in Docker requires the Android SDK + licenses and additional environment setup. The base image may already provide the SDK in many cases, but you may need to:

- Accept Android SDK licenses within the container: `yes | sdkmanager --licenses`
- Install target SDK packages if missing (using `sdkmanager`).
- Mount Android SDK/Gradle caches as volumes to speed builds.

Example Android build (may require running the container with additional privileges or mounts):

  # inside container
  flutter build apk --release

Troubleshooting

- If `flutter pub get` fails during image build, run `docker compose run --rm flutter flutter pub get` interactively so you can see the error.
- For emulator or desktop builds, you may need to forward X11 or use additional Docker options; those are outside this minimal setup.

Extending

- Add a build script in `tool/` or `scripts/` and call it from a Dockerfile stage to produce CI artifacts.
- Add caching volumes for `.pub-cache` and `.gradle` in `docker-compose.yml` to speed repeated builds.
