require 'autoingestion'

describe Autoingestion do

  before(:each) do
    @autoingestion = Autoingestion.new
  end

  it "should have a method to create post request body" do
    @autoingestion.should respond_to("create_post_body")
  end

  it "should return String from create_post_body" do
    post_body = @autoingestion.create_post_body
    test_post_body = "foo"
    post_body.class.should == test_post_body.class
  end

  it "should have proper number of entries in data from create_post_body" do
    post_body = @autoingestion.create_post_body
    post_body.should_not be_empty
    post_body.count("&").should == 6
  end

  it "should have methods to set request information" do
    @autoingestion.should respond_to("username")
    @autoingestion.should respond_to("password")
    @autoingestion.should respond_to("vendor_number")
    @autoingestion.should respond_to("type_of_report")
    @autoingestion.should respond_to("date_type")
    @autoingestion.should respond_to("report_type")
    @autoingestion.should respond_to("report_date")
  end

  it "should have a method to request reports" do
    @autoingestion.should respond_to("perform_request")
  end


end
