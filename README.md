# Rails Templates
Jump start your Rails development with my personal templates.

## Testing
Get a Rails app ready to deploy with following testing tools:
- RSpec
- Factory Bot
- Rubocop

```bash
rails new \
--database postgresql \
-T \
-m https://raw.githubusercontent.com/ma-thibaud/rails-templates/master/testing.rb \
CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```

## API
Get a Rails API-only app ready to deploy with the following:
- Testing: RSpec, Factory Bot, Rubocop
- CMS: Devise and Active Admin


```bash
rails new \
--api \
--database postgresql \
-T \
-m https://raw.githubusercontent.com/ma-thibaud/rails-templates/master/api.rb \
CHANGE_THIS_TO_YOUR_RAILS_APP_NAME
```

Start the server and visit http://localhost:3000/admin and log in as the default user:

User: admin@example.com
Password: password

Create and register a new model:
```bash
rails generate model MyModel
rails db:migrate
rails generate active_admin:resource MyModel
```
