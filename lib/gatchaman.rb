require "gatchaman/version"
require "nokogiri"
require "mime/types"
require "open-uri"
require "base64"
class Gatchaman
  def initialize(document_root, current_dir)
    @document_root = chomp_last_slash(document_root)
    @current_dir = chomp_last_slash(current_dir)
  end

  def data_uri_schemize(html_string)
    doc = Nokogiri::HTML::DocumentFragment.parse(html_string)
    elements = doc.xpath("*[@src]")
    elements.each do |elements|
      elements[:src] = to_data_scheme(extract_path(elements[:src]))
    end
    doc.to_s
  end

  private
  def chomp_last_slash(str)
    str.gsub(/\/$/,"")
  end
  def extract_path(path)
    if path =~ /^http/
      return path
    elsif path =~ /^\//
      return @document_root + path
    else
      return @current_dir + "/" + path
    end
  end
  def to_data_scheme(path)
    mime = MIME::Types.type_for(path).first
    image_binary = open(path, "r:ASCII-8BIT"){|f|
      f.read(nil)
    }
    base64 = Base64.encode64(image_binary).gsub(/\s/,'')
    "data:#{mime.to_s};base64,#{base64}"
  end
end
