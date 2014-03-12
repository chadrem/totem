# Totem

Totem is a Ruby gem for creating Ruby projects.
It's like having a Rails project folder without the Rails dependency.
Use it for simple prototyping or building non-Rails applications (including servers).

##### Goals:
- Use a Ruby on Rails inspired folder structure because many developers are familiar with it.
- Keep the gem lightweight with simple easy to understand code.
- Prefer built in Ruby classes and methods in order to avoid third party dependencies.
- Design from day one for MRI and JRuby.
- Make it extensible through gems and directly in a project project.
- Maintain thread safety so that it can be used with gems such as [Tribe](https://github.com/chadrem/tribe) or [Celluloid](https://github.com/celluloid/celluloid).

##### Features:
- console
- logger
- environments (development, production, stage, etc).

##### Coming soon:
- ActiveRecord add-on gem.

## Installation

Add this line to your application's Gemfile:

    gem 'totem'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install totem

## Create a project

Create a new project called `my_app` in the current directory:

    $ totem new my_app

You must now setup Bundler (and rvm, rbenv, etc) for your new project:

    $ bundle

You can now create your custom classes in the `app` directory.
You will need to manually `require` your classes in `app/loader.rb` since Tribe doesn't come with an auto-loader due to thread safety.

Totem comes with an IRB based console similar to Rails:

    $ totem console

## Totem API

Totem comes with some built in methods that should be familiar to any Rails developer.
Copy and paste the below code into `app/my_class.rb`.
You can then run this example in the `totem console` by entering `MyClass.new.run`.
Don't forget, you need to register this class in `app/loader.rb` with `require my_class`.

    class MyClass
      def run
        puts 'Totem provides a few class variables to simplify programming...'
        puts "  Root: #{Totem.root}"
        puts "  Environment: #{Totem.env}"
        puts

        puts 'Totem includes a logger...'
        Totem.logger.error('Example error log entry')
        puts "  Check your #{Totem.log_file_path} to see the entry."
        puts

        puts 'Enjoy!'
      end
    end

## Add-ons

Below is a list of available add-ons that extend the functionality of a Totem project:

- [totem_activerecord](https://github.com/chadrem/totem_activerecord): The powerful Rails database library

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
