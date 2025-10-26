# Use an image with Flutter SDK preinstalled
# cirrusci/flutter images are commonly used in CI and include Flutter and SDK tooling
FROM cirrusci/flutter:stable

# minimal utilities
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
    curl \
    unzip \
    xz-utils \
    lsb-release \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Copy pubspec first to leverage Docker layer caching for dependencies
COPY pubspec.* ./

# Attempt to fetch dependencies (will run either offline cached or online)
RUN flutter pub get || flutter pub get --offline || true

# Copy the rest of the project
COPY . .

# Useful environment variables and default workdir
ENV FLUTTER_ROOT=/opt/flutter
ENV PUB_HOSTED_URL=https://pub.dev

# Expose ports commonly used for web/devtools when running `flutter run -d web-server`
EXPOSE 8080 9222

# Default to an interactive shell so you can use the container for dev tasks
CMD ["bash"]
