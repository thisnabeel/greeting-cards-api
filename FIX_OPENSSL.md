# Fix OpenSSL Certificate Issue

You have two problems:
1. ✅ **Bundler 4.0.4 is installed** - Good!
2. ❌ **OpenSSL certificate error** - Needs fixing

## Quick Fix

The error shows OpenSSL is looking for certificates at:
- `/opt/homebrew/etc/openssl@3/cert.pem`
- `/opt/homebrew/etc/openssl@3/certs`

### Solution 1: Install/Update OpenSSL Certificates

```bash
# Update Homebrew
brew update

# Reinstall openssl@3 to get fresh certificates
brew reinstall openssl@3

# Or manually update certificates
brew install ca-certificates
```

### Solution 2: Set SSL Certificate Path

If certificates exist but Ruby can't find them:

```bash
# Find where certificates are
brew --prefix openssl@3

# Set environment variable (add to ~/.zshrc)
export SSL_CERT_FILE=$(brew --prefix openssl@3)/etc/openssl@3/cert.pem
export SSL_CERT_DIR=$(brew --prefix openssl@3)/etc/openssl@3/certs

# Reload shell
source ~/.zshrc
```

### Solution 3: Use System Certificates

```bash
# Use macOS system certificates
export SSL_CERT_FILE=/etc/ssl/cert.pem
# Or
export SSL_CERT_FILE=/usr/local/etc/openssl@3/cert.pem
```

### Solution 4: Reinstall Ruby with OpenSSL

```bash
# Uninstall current Ruby
rbenv uninstall 3.2.0

# Make sure openssl@3 is installed
brew install openssl@3

# Reinstall Ruby with OpenSSL support
RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)" rbenv install 3.2.0
rbenv local 3.2.0

# Verify OpenSSL works
ruby -ropenssl -e "puts OpenSSL::X509::DEFAULT_CERT_FILE"
```

## After Fixing OpenSSL

Once OpenSSL is fixed, you can run:

```bash
cd /Users/thisnabeel/Desktop/thisnabeel/greeting-cards/api

# Use the new bundler explicitly
bundle _4.0.4_ install
```

## Alternative: Use Bundler Directly

If you continue having issues, you can use the bundler gem directly:

```bash
# Find bundler executable
gem which bundler

# Use full path
/Users/thisnabeel/.rbenv/versions/3.2.0/bin/bundle install
```

## Verify the Fix

Test that SSL works:

```bash
ruby -ropenssl -e "require 'net/http'; puts Net::HTTP.get(URI('https://www.google.com'))"
```

If this works, bundler should work too.

