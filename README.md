# Gatchaman

Gatchaman is a gem to replace src values in HTML documents with data URI scheme

*THE SOFTWARE IS IT'S IN ALPHA QUALITY. IT MAY CHANGE THE API WITHOUT NOTICE.*

## Installation

    $ gem install gatchaman

## Usage

    $ gatchan input_file [-r document_root] [-c current_directory] [--expand-js] [--expand-css]

or

    gatchaman = Gatchaman.new(document_root: document_root, current_dir: current_directory, expand_js: true, expand_css: true)
    gatchaman.data_uri_schemize(html_string)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

wneko [js and css expand options]