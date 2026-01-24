# Fix JSON Gem Compatibility Issue

The error you're seeing is because the `json` gem version 1.8.6 is incompatible with Ruby 3.2.0.

## The Problem

```
wrong number of arguments (given 2, expected 1) (ArgumentError)
```

This happens because `json-1.8.6` uses an old API that's incompatible with Ruby 3.2.

## Solution

I've updated your Gemfile to require `json ~> 2.7`. Now you need to update the lockfile:

### Option 1: Update JSON Gem (Recommended)

```bash
cd /Users/thisnabeel/Desktop/thisnabeel/greeting-cards/api

# Remove the old lockfile temporarily
mv Gemfile.lock Gemfile.lock.backup

# Install with new json gem
bundle install
```

### Option 2: Force Update JSON Gem

If you have OpenSSL issues, try:

```bash
cd /Users/thisnabeel/Desktop/thisnabeel/greeting-cards/api

# Update just the json gem
gem install json -v 2.7.2

# Then update bundle
bundle update json
```

### Option 3: Manual Lockfile Edit

If bundle commands fail due to OpenSSL, you can manually edit `Gemfile.lock`:

1. Find the line: `json (1.8.6)`
2. Replace it with: `json (2.7.2)`
3. Update the checksum line for json (you may need to remove it and let bundle regenerate)

Then run:
```bash
bundle install --local
```

## After Fixing

Once the json gem is updated, try running the server again:

```bash
rails s
```

The json gem 2.7.x is fully compatible with Ruby 3.2.0 and Rails 8.1.

