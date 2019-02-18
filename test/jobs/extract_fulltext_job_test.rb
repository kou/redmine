require 'test_helper'

class ExtractFulltextJobTest < ActiveJob::TestCase
  fixtures :issues, :users

  def test_should_extract_fulltext
    att = nil
    Redmine::Configuration.with 'enable_fulltext_search' => false do
      att = Attachment.create(
        :container => Issue.find(1),
        :file => uploaded_test_file("testfile.txt", "text/plain"),
        :author => User.find(1),
        :content_type => 'text/plain')
    end
    att.reload
    assert_nil att.fulltext

    ExtractFulltextJob.perform_now(att.id)

    att.reload
    assert_equal("this is a text file for upload tests with multiple lines",
                 att.fulltext)
  end

end
