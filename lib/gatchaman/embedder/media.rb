require 'gatchaman/embedder/generic'

class Gatchaman::Embedder::Media < Gatchaman::Embedder::Generic
  TARGET_ELEMENTS = [
    :img,
    :audio,
    :video
  ].freeze

  def embed(doc)
    doc.css(TARGET_ELEMENTS.join(',')).each do |element|
      src = element[:src] or next
      element[:src] = Gatchaman::DataScheme.new(path(src))
    end
  end
end
