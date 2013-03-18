require 'gatchaman/embedder/generic'

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
    css_content.gsub(/\burl\b\(([^)]+)\)/) do
      data_scheme = Gatchaman::DataScheme.new(path($1))
      "url(#{data_scheme})"
    end
  end
end
