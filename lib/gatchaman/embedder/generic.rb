class Gatchaman
  module Embedder
    class Generic
      def initialize(options)
        @options = options
      end

      def expand(doc)
        doc
      end

      private
      def path(path)
        Path.new(path, @options)
      end

      def inner_html_from_file(filename)
        ["", open(path(filename)).read.chomp, ""].join("\n")
      end
    end
  end
end
