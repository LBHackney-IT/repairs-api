# Repairs API

A Rails API to replace the previous service API for the Repairs Hub.

| Dependency | Version |
| ---------- | ------- |
| Ruby       | 2.7.2   |
| Rails      | 6.0.3   |
| Postgresql | 1.2.3   |

## Preflight

### Clone the project

```sh
$ git clone git@github.com:LBHackney-IT/repairs-api.git
```

### First Time Setup

#### Install the project's dependencies using bundler:

```sh
$ bundle install
```

#### Create the databases

```sh
$ rails db:prepare
```

#### Tests

You can run the full test suite using following command:

```sh
$ rspec
```

You can run all the tasks set in the rakefile `bundle_audit brakeman rubocop spec` using :

```sh
$ rake
```

#### Debugging using `binding.pry`

1. Initially we have installed pry-byebug to development and test group on our Gemfile

```ruby
group :development, :test do
  # ..
  gem 'pry-byebug'
  # ..
end
```

2. Add binding.pry to the desired place you want to have a look on your rails code:

```ruby
def index
  binding.pry
end
```

#### Start the server:

```sh
$ rails server
```

#### Start a rails console:

```sh
$ rails console
```

## Github Actions

We use Github Actions as part of our continuous integration process to build, run and test the application.

## Rails credentials

To run the app locally, you’ll need to have the Rails master key and test key set within the app. Copy the master key password from the Hackney Repairs V2 folder in Unboxed’s 1Password and save it to a `master.key` file in the config directory (i.e. where credentials.yml.enc lives). Save the password from the test key to `config/credentials/test.key` Read https://edgeguides.rubyonrails.org/security.html#custom-credentials for more info on this approach.

If using a service such as Postman API to test API requests, you will need the x-api-key and endpoint url which can also be found in the Hackney Repairs V2 1password vault.

### Webmock

We use webmock to mock real network interactions, for example the Hackney platform APIs.
