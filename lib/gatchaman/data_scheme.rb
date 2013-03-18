require "mime/types"
require "open-uri"
require "base64"

class Gatchaman
  class DataScheme < String
    def initialize(path)
      @path = path
      super(to_s)
    end

    def mime_type
      @mime_type ||= MIME::Types.type_for(@path).first.to_s
    end

    def binary
      @binary ||= open(@path, "r:ASCII-8BIT") {|f| f.read(nil) }
    end

    def base64
      @base64 ||= Base64.encode64(binary).gsub(/\s/, '')
    end

    def to_s
      "data:#{mime_type};base64,#{base64}"
    end
  end
end
