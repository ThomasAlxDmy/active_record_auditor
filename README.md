# ActiveRecordAuditor

Audit Framework For ActiveRecord

so general idea, is
the project will extend active record
each table, will have a duplicate table, with version name, action, username fields added
once the table is setup, all changes to the table will be wrapped in a transaction
which copies the previous version with the username, an incrementing version number, and the action (create update delete).
as well as making the changes to the specified row
it records all the previous version
there should be a flag that either blocks changes with no user or records them.
and the ability to split the audit tables into a table per monthly tables
so that you can eventually trim tables from older months for size preservation
so if your table name is titles you'll have titles, titles_audit_april_2014, titles_audit_may_2014, etc.
and if you only want to keep record for so long


TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_auditor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_auditor

## Usage

TODO: Write usage instructions here

## Development

Put your Ruby code in the file `lib/active_record_auditor`. To experiment with that code, run `bin/console` for an interactive prompt.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_record_auditor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
