# Rails 4.2 → 8.0 Upgrade Guide

This document outlines the changes made to upgrade your Rails application from version 4.2.8 to 8.0.0.

## Summary of Changes

### 1. Ruby Version Update
- **Changed**: Ruby version from `2.5.7` to `>= 3.1.0` (required for Rails 8)
- **Action Required**: Install Ruby 3.1 or higher using rbenv, rvm, or your preferred Ruby version manager

### 2. Rails Version Upgrade Path
The upgrade followed this path:
- Rails 4.2.8 → 5.0 → 5.2 → 6.0 → 6.1 → 7.0 → 7.1 → 8.0

### 3. Gem Updates
The following gems were updated for Rails 8 compatibility:
- `rails`: `4.2.8` → `~> 8.0.0`
- `pg`: `~> 0.15` → `~> 1.0`
- `aws-sdk`: `~> 2.0.22` → `aws-sdk-s3 ~> 1.0` (AWS SDK v2 is deprecated)
- `jbuilder`: `~> 2.0` → `~> 2.11`
- `sass-rails`: `~> 5.0` → `~> 5.1`
- `coffee-rails`: `~> 4.1.0` → `~> 5.0`
- `web-console`: `~> 2.0` → `~> 3.0`
- `devise`: Updated to `~> 4.9` (latest stable)
- `uglifier`: Commented out (optional in Rails 8)

### 4. Configuration File Updates

#### `config/application.rb`
- Removed deprecated `config.active_record.raise_in_transactional_callbacks`
- Updated to use `require_relative` instead of `File.expand_path`
- Added `config.load_defaults 8.0`
- Added `config.autoload_lib(ignore: %w(assets tasks))` for Rails 7+

#### `config/boot.rb`
- Updated to use `__dir__` instead of `__FILE__`

#### `config/environment.rb`
- Updated to use `require_relative` instead of `File.expand_path`

#### `config/environments/development.rb`
- Updated to Rails 8 configuration format
- Changed `config.cache_classes` to `config.enable_reloading`
- Added `config.server_timing = true`
- Updated caching configuration
- Added `config.active_storage` configuration
- Added `config.active_record.verbose_query_logs = true`
- Added `config.active_job.verbose_enqueue_logs = true`
- Removed deprecated `config.assets` settings

#### `config/environments/production.rb`
- Updated to Rails 8 configuration format
- Changed `config.cache_classes` to `config.enable_reloading`
- Updated logging configuration
- Added `config.active_storage` configuration
- Updated static file serving configuration

#### `config/environments/test.rb`
- Updated `config.serve_static_files` to `config.public_file_server.enabled`
- Removed deprecated `config.active_support.test_order`

#### `config.ru`
- Updated to use `require_relative` instead of `File.expand_path`
- Added `Rails.application.load_server`

#### `Rakefile`
- Updated to use `require_relative` instead of `File.expand_path`

### 5. Model Updates

#### `app/models/customization.rb`
- Fixed incorrect association: `belongs_to :customizations` → `belongs_to :product`

#### `app/models/sale.rb`
- Updated deprecated validation: `validates_uniqueness_of :guid` → `validates :guid, uniqueness: true`

### 6. New Files Created

#### `config/storage.yml`
- Created Active Storage configuration file (required for Rails 8)

## Next Steps

### 1. Install Ruby 3.1+
```bash
# Using rbenv
rbenv install 3.1.0
rbenv local 3.1.0

# Using rvm
rvm install 3.1.0
rvm use 3.1.0
```

### 2. Update Dependencies
```bash
cd api
bundle update
```

### 3. Run Database Migrations
```bash
rails db:migrate
```

### 4. Test the Application
```bash
# Start the server
rails server

# Run tests
rails test
```

### 5. Check for Deprecation Warnings
- Monitor the logs for any deprecation warnings
- Address any remaining compatibility issues

## Potential Issues to Watch For

1. **Active Storage**: If you're using file uploads, ensure Active Storage is properly configured
2. **Secrets vs Credentials**: Rails 5.2+ uses encrypted credentials. Consider migrating from `secrets.yml` to `config/credentials.yml.enc`
3. **Zeitwerk Autoloader**: Rails 7+ uses Zeitwerk by default. Ensure all your class names follow Rails naming conventions
4. **Asset Pipeline**: Rails 7+ uses importmap or other modern asset management. Consider updating your asset pipeline
5. **Turbolinks**: Turbolinks 5 is deprecated. Consider migrating to Turbo (Hotwire) or removing it

## Breaking Changes to Review

1. **belongs_to is required by default** (Rails 5+): All `belongs_to` associations are required by default. Add `optional: true` if needed
2. **ActionController::Parameters**: Parameters are no longer inheriting from Hash in Rails 5+
3. **ActiveRecord callbacks**: Some callback behavior changed in Rails 5+
4. **Asset Pipeline**: Significant changes in Rails 6+ with Webpacker, and Rails 7+ with importmap

## Testing Checklist

- [ ] All controllers respond correctly
- [ ] Database queries work as expected
- [ ] File uploads/downloads work (if applicable)
- [ ] Authentication (Devise) works correctly
- [ ] API endpoints return correct responses
- [ ] Background jobs (if any) work correctly
- [ ] Email delivery works (if applicable)
- [ ] Static assets are served correctly

## Additional Resources

- [Rails Upgrade Guide](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html)
- [Rails 8.0 Release Notes](https://edgeguides.rubyonrails.org/8_0_release_notes.html)
- [Rails 7.1 Release Notes](https://edgeguides.rubyonrails.org/7_1_release_notes.html)
- [Rails 6.1 Release Notes](https://edgeguides.rubyonrails.org/6_1_release_notes.html)

## Notes

- The upgrade maintains backward compatibility where possible
- All existing functionality should continue to work
- Some gems may need additional updates based on your specific usage
- Consider running the application in development mode first to catch any issues before deploying to production

