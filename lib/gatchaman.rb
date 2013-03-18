require "gatchaman/version"
require "gatchaman/embedder"

class Gatchaman
  EMBED_OPTION_KEYS = [
    :document_root,
    :current_dir,
  ].freeze

  def initialize(options = {})
    @options = options
    @embed_options = {}
    EMBED_OPTION_KEYS.each do |key|
      @embed_options[key] = @options[key] if @options[key]
    end
  end

  def embedders
    if @embedders.nil?
      @embedders = []
      @embedders << Gatchaman::Embedder::Media.new(@embed_options)
      @embedders << Gatchaman::Embedder::JS.new(@embed_options)  if @options[:expand_js]
      @embedders << Gatchaman::Embedder::CSS.new(@embed_options) if @options[:expand_css]
    end
    @embedders
  end

  def data_uri_schemize(html_string)
    doc = if Nokogiri.XML(html_string).root.name == "html"
            Nokogiri::HTML::Document.parse(html_string)
          else
            Nokogiri::HTML::DocumentFragment.parse(html_string)
          end

    embedders.each do |embedder|
      embedder.embed(doc)
    end

    doc.to_s
  end
end
