require_relative '../../../test_helper'

class Redmine::TextExtractorTest < ActiveSupport::TestCase
  fixtures :projects, :users, :attachments

  setup do
    @project = Project.find_by_identifier 'ecookbook'
    set_fixtures_attachments_directory
    @dlopper = User.find_by_login 'dlopper'
  end

  def attachment_for(filename, content_type = nil)
    Attachment.new(container: @project,
                   file: uploaded_test_file(filename, content_type),
                   filename: filename,
                   author: @dlopper).tap do |a|
      a.content_type = content_type if content_type
      a.save!
    end
  end

  test "should extract text from text file" do
    a = attachment_for "testfile.txt"
    te = Redmine::TextExtractor.new a
    assert text = te.text
    assert_match /this is a text file for upload tests with multiple lines/, text
  end

  test "should extract text from csv" do
    a = attachment_for "import_dates.csv"
    te = Redmine::TextExtractor.new a
    assert text = te.text
    assert_match /Invalid start date/, text
  end

end
