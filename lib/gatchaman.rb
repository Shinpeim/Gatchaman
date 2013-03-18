require "gatchaman/version"
require "nokogiri"
require "mime/types"
require "open-uri"
require "base64"
class Gatchaman
  SCHEMIZE_TARGET_ELEMENTS = [
    :img,
    :audio,
    :video
  ].freeze
  
  def initialize(options = {})
    @document_root = chomp_last_slash(options[:document_root])
    @current_dir   = chomp_last_slash(options[:current_dir])

    @expand_js  = options[:expand_js]  || false
    @expand_css = options[:expand_css] || false
  end

  def data_uri_schemize(html_string)
    doc = if Nokogiri.XML(html_string).root.name == "html"
            Nokogiri::HTML::Document.parse(html_string)
          else
            Nokogiri::HTML::DocumentFragment.parse(html_string)
          end

    doc.css(SCHEMIZE_TARGET_ELEMENTS.join(',')).each do |element|
      element[:src] = to_data_scheme(extract_path(element[:src]))
    end

    expand_js(doc)  if @expand_js
    expand_css(doc) if @expand_css

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
  def inner_html_from_file(filename)
    ["", open(extract_path(filename)).read.chomp, ""].join("\n")
  end
  def expand_js(doc)
    doc.css('script').each do |element|
      expand_js_element(element)
    end
    doc
  end
  def expand_css(doc)
    doc.css('link[rel=stylesheet]').each do |element|
      expand_css_element(element)
    end
    doc
  end
  def expand_js_element(element)
    return if element[:src].nil? or element[:src].size == 0
    element.inner_html += html_comment_out(inner_html_from_file(element[:src]))
    [:src, :charset].each {|attr| element.delete(attr.to_s)}
  end
  def expand_css_element(element)
    element.name = "style"
    content = inner_html_from_file(element[:href])
    content = expand_css_url(content)
    element.inner_html = content
    element.attributes.keys.each do |attr_name|
      next if [:media, :type].include? attr_name.to_sym
      element.delete(attr_name)
    end
  end
  def expand_css_url(css_content)
    css_content.gsub(/\burl\b\(([^)]+)\)/) do
      data_scheme = to_data_scheme(extract_path($1))
      "url(#{data_scheme})"
    end
  end
  def html_comment_out(content)
    ["<!--", content, "-->"].join("\n")
  end
end
