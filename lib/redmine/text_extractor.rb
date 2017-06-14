module Redmine
  class TextExtractor

    def initialize(attachment)
      @attachment = attachment
    end

    # returns the extracted fulltext or nil if no matching handler was found
    # for the file type.
    def text
      Plaintext::Resolver.new(@attachment.diskfile,
                              @attachment.content_type).text
    rescue Exception => e
      Rails.logger.error "error in fulltext extraction: #{e}"
      raise e unless e.is_a? StandardError # re-raise Signals / SyntaxErrors etc
    end

  end
end

