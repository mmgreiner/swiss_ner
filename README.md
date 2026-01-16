# SwissNer

This gem uses [SpaCy][spacy] to detect named entities in the given input. The standard [spacy] model was extended by
Swiss phone numbers and Swiss social security numbers.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add swiss_ner --github mmgreiner/swiss_ner
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install swiss_ner --github mmgreiner/swiss_ner
```

The installer should do this already, but sometimes you may have to manually install the spacy python package. Note that python must be `3.10` for [spacy] to work correctly.

```bash
python --version
Python 3.10.19      # must be 3.10
pip install spacy
python -m spacy download de_core_news_sm
```

[spacy]: https://spacy.io/

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmgreiner/swiss_ner.
