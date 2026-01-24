# Fix Bundler Compatibility Issue

You're encountering two issues:
1. **Old Bundler version (1.17.3)** is incompatible with Ruby 3.2.0 (uses deprecated `untaint` method)
2. **OpenSSL certificate error** preventing gem updates

## Solution: Fix OpenSSL and Update Bundler

### Option 1: Reinstall Ruby 3.2.0 with OpenSSL support (Recommended)

```bash
# Install OpenSSL via Homebrew if not already installed
brew install openssl@3

# Reinstall Ruby 3.2.0 with OpenSSL support
rbenv install --force 3.2.0
rbenv local 3.2.0

# Update rubygems
gem update --system

# Install latest bundler
gem install bundler
```

### Option 2: Quick Fix - Install Bundler Locally

If you can't fix OpenSSL right now, try installing bundler from a local source:

```bash
# Download bundler gem manually (if you have access to another machine)
# Or try installing with --no-document flag
gem install bundler --no-document

# Or use the system bundler if available
which -a bundle
```

### Option 3: Use rbenv to reinstall with proper OpenSSL

```bash
# Uninstall current Ruby 3.2.0
rbenv uninstall 3.2.0

# Make sure you have openssl installed
brew install openssl@3

# Reinstall with openssl
RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)" rbenv install 3.2.0

# Set local version
rbenv local 3.2.0

# Update and install bundler
gem update --system
gem install bundler
```

### Option 4: Temporary Workaround - Use Ruby 3.1.x

If you need to proceed immediately, you could use Ruby 3.1.x which might have better compatibility:

```bash
rbenv install 3.1.6
rbenv local 3.1.6
gem install bundler
```

**Note**: Rails 8.2 requires Ruby 3.2.0+, so if you use Ruby 3.1, you'll need to use Rails 8.0 instead.

## After Fixing Bundler

Once bundler is updated, run:

```bash
cd api
bundle install
```

This should resolve the `untaint` error and allow you to proceed with the Rails upgrade.

