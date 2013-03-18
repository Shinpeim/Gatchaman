require 'uri'
require 'pathname'

class Gatchaman
  class Path < String
    HTTP_REGEX = /^(?:shttp|http|https):/

    def initialize(path, options = {})
      @path = path
      @document_root = options[:document_root]
      @current_dir   = options[:current_dir]
      super(normalized)
    end

    def normalized
      if @path =~ HTTP_REGEX
        @path
      else
        path = Pathname.new(@path)
        if path.relative?
          Pathname.new(@current_dir).join(@path).to_s
        else
          Pathname.new(@document_root).join(path.relative_path_from(root)).to_s
        end
      end
    end

    private
    def root
      Pathname.new("/")
    end
  end
end
