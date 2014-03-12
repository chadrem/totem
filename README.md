# Totem

Totem is a framework for creating Ruby projects.
It's like having a Rails project folder without the Rails dependency.

Features:
- Ruby on Rails inspired folder structure.
- Lightweight and simple code.
- Integrated console.
- Uses built in Ruby classes and avoids depending on 3rd party gems.
- Designed for MRI and JRuby.
- Easily extensible through gems or directly in your project (ActiveRecord gem coming soon).
- Designed for multi-threaded applications.

## Installation

Add this line to your application's Gemfile:

    gem 'totem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install totem

## Usage

Create a new project called "my_app" in the current directory:

    $ totem new my_app

You must now setup Bundler (and rvm, rbenv, etc) for your new project:

    $ bundle

You can now create your custom classes in the "app" directory.
You will need to manually "require" your classes in "app/loader.rb" since there isn't an auto-loader.

Totem comes with an IRB based console similar to Rails:

    $ totem console

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
