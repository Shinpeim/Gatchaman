require 'gatchaman/embedder/generic'
require 'parslet-css'

class Gatchaman::Embedder::CSS < Gatchaman::Embedder::Generic
  def embed(doc)
    doc.css('link[rel=stylesheet]').each do |element|
      embed_element(element)
    end
    doc.css('style').each do |element|
      element.content = embed_all_url_in_css(element.content)
    end
    doc
  end

  private
  def embed_element(element)
    element.name = "style"
    content = inner_html_from_file(element[:href])
    element.inner_html = content
    element.attributes.keys.each do |attr_name|
      next if [:media, :type].include? attr_name.to_sym
      element.delete(attr_name)
    end
  end

  def embed_all_url_in_css(css_content)
    parsed = parser.parse(css_content)
    return css_content if parsed.is_a? Parslet::Slice
    slices = parsed.map{|p| p[:url] }.compact.sort_by(&:line_and_column).reverse
    slices.each do |slice|
      range = Range.new(slice.offset, slice.offset + slice.str.length - 1)
      css_content[range] = Gatchaman::DataScheme.new(path(slice.str))
    end
    css_content
  end

  def parser
    @parser ||= ParsletCSS::Parser.new
  end
end
