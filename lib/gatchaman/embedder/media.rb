require 'gatchaman/embedder/generic'

class Gatchaman::Embedder::Media < Gatchaman::Embedder::Generic
  TARGET_ELEMENTS = [
    :img,
    :audio,
    :video
  ].freeze

  def embed(doc)
    doc.css(TARGET_ELEMENTS.join(',')).each do |element|
      element[:src] = Gatchaman::DataScheme.new(path(element[:src]))
    end
  end
end
