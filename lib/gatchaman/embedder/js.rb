require 'gatchaman/embedder/generic'

class Gatchaman::Embedder::JS < Gatchaman::Embedder::Generic
  def embed(doc)
    doc.css('script').each do |element|
      embed_element(element)
    end
    doc
  end

  private
  def embed_element(element)
    return if element[:src].nil? or element[:src].size == 0
    element.inner_html += html_comment_out(inner_html_from_file(element[:src]))
    [:src, :charset].each {|attr| element.delete(attr.to_s)}
  end

  def html_comment_out(content)
    ["<!--", content, "-->"].join("\n")
  end
end
