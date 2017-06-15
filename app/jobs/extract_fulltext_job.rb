class ExtractFulltextJob < ActiveJob::Base
  queue_as :text_extraction

  def perform(attachment_id)
    if att = Attachment.find_by_id(attachment_id) and
      att.readable? and
      text = Redmine::TextExtractor.new(att).text

      att.update_column :fulltext, text
    end
  end

end
