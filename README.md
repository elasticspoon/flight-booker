# [Odin Flight Booker](https://web-production-9a89.up.railway.app)

- [Odin Flight Booker](#odin-flight-booker)
  - [Changelog](#changelog)
  - [Goals](#goals)
  - [Tech stack](#tech-stack)
  - [Getting the site running for development](#getting-the-site-running-for-development)
    - [Making mailers work](#making-mailers-work)
  - [Custom settings for development](#custom-settings-for-development)
  - [Launching in production](#launching-in-production)
  - [Site overview](#site-overview)

## Changelog

- 10/27/22: added mailers, configuration info [[#Making mailers work|here]]

## Goals

This was a project where my intent was to get more practice with several new technologies in multiple areas of full stack web development.

On the frontend I used PostCSS with multiple CSS plugins as opposed to Tailwind. I also followed the BEM approach to structuring my CSS classes.

Closer to the middle of the stack I made use of TurboDrive and TurboFrames to minimize full page reloads between form submissions. I added some light JavaScript to make form submissions occur on change in HTML forms.

On the backend I deployed the website on different services, instead of using AWS. I opted to use Supabase to host my Postgres database and Render to host the actual application.

## Tech stack

Ruby on Rails, PostCSS, Hotwire (specifically TurboDrive and TurboFrames), Railway for website hosting and Supabase for database hosting.

## Getting the site running for development

Clone the repository:

```sh
git clone https://github.com/elasticspoon/flight-booker.git
# or
git clone git@github.com:elasticspoon/flight-booker.git
```

Install dependencies and set up the database:

```sh
cd flight-booker
bundle install
npm install
rails db:create
rails db:migrate
```

Seed the database and run the application:

```sh
rails db:seed
bin/dev
```

### Making mailers work

An update to the site added mailers that will send emails to all passengers making a booking. This functionality is not set up to work in production, it also currently defaults to using the letter opener gem in development.

`development.rb` contains the following code, with the active section being settings to prevent mail from being sent and instead open it with the letter opener gem.

```ruby
#config/environments/development.rb
config.action_mailer.delivery_method = :letter_opener
config.action_mailer.perform_deliveries = true
config.action_mailer.default_url_options = { host: 'localhost:3000' }
```

If needed those settings can be replaced with the following ones to use Gmail as a mailer instead. You will need to provide your Gmail username and password as environment variables to make the mailer work.

```ruby
#config/environments/development.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.default_url_options = { host: 'localhost:3000', protocol: 'http' }
config.action_mailer.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  user_name:            ENV.fetch('gmail_username', nil),
  password:             ENV.fetch('gmail_password', nil),
  authentication:       'plain',
  enable_starttls_auto: true
}
```

Note: If your Gmail uses two factor authentication you will need to create an app password using [these steps](https://support.google.com/accounts/answer/185833?hl=en).

## Custom settings for development

Development is still set up the way I had it when I was working on the site. This means the when launching the server with `bin/dev` it will automatically open VSCode and attempt to connect the debugger.

This can be changed in the `Procfile.dev` by modifying `web: bundle exec rdbg -n --open=vscode -c -- bin/rails server -p 3000` to `web: bundle exec bin/rails server -p 3000`.

## Launching in production

Create a new master key with `bin/rails credentials:edit`. **Do not add `master.key` to version control**.

Precompile the application's assets for production: `rails assets:precompile`.

Figure out the database connection. My production database requires the following environment variables to be set for connection. (That is the stuff in quotes `'RDS_PORT'`, etc.)

```yml
database: <%= ENV['RDS_DB_NAME'] %>
username: <%= ENV['RDS_USERNAME'] %>
password: <%= ENV['RDS_PASSWORD'] %>
host: <%= ENV['RDS_HOSTNAME'] %>
port: <%= ENV['RDS_PORT'] %>
```

Environment variables can be simply set in the bash shell with `export VAR_NAME=var_value`. On a PAAS site such a Heroku you will want to enter those values wherever they allow setting environment variables.

Finally, launch the site with `bundle exec rails s -e production`.

## Site overview

The basis of the site is a form on the `/flights` page that sends a `GET` request with the form contents to the `FlightsController`. This controller in turn narrows down all the available flights that may be shown to the user from a pre-seeded database.

The list of flights is a turbo-frame allowing the rest of the page to avoid being reloaded between searches. Each of the flights within the list is also a lazy-loaded turbo-frame to only load it if the user scrolls that far.

Upon selecting a flight to book the `BookingController` builds a `Booking` with the given flight and passenger amount. The passenger information is then filled in by the user on the next page and submitted as nested properties for the `Booking`.
