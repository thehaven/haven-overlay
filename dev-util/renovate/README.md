# Renovate for Gentoo

This package provides the [Renovate](https://renovatebot.com) CLI tool for automated dependency updates.

## Installation

```bash
emerge dev-util/renovate
```

## Features & Modularization

The ebuild provides several USE flags to control platform-specific dependencies:

- `aws`: Enables dependencies for AWS CodeCommit.
- `azure`: Enables dependencies for Azure DevOps.
- `google`: Enables dependencies for Google Cloud / GCP platforms.
- `telemetry`: Enables OpenTelemetry instrumentation for monitoring.

## Configuration

Renovate requires a platform-specific token to operate. You can set this via environment variables or a configuration file (`renovate.json` or `config.js`).

### Example (GitHub)

```bash
export RENOVATE_TOKEN=ghp_your_token
renovate your/repository
```

## Self-Hosting

For detailed self-hosting instructions, visit the [official documentation](https://docs.renovatebot.com/self-hosted-configuration/).

## Caching

It is highly recommended to set a persistent cache directory to speed up subsequent runs:

```bash
export RENOVATE_CACHE_DIR=/var/cache/renovate
```
