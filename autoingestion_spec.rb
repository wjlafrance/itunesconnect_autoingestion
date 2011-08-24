require 'autoingestion'

describe Autoingestion do

  before(:each) do
    @autoingestion = Autoingestion.new
  end

  it "should have method to create report request form data hash" do
    @autoingestion.should respond_to("create_post_hash")
  end

  it "should have a method to create post request body" do
    @autoingestion.should respond_to("create_post_body")
  end

  it "should return Hash from create_post_hash" do
    post_hash = @autoingestion.create_post_hash
    test_post_hash = {'FOO' => 'bar'}
    post_hash.class.should == test_post_hash.class
  end

  it "should return String from create_post_body" do
    post_body = @autoingestion.create_post_body
    test_post_body = "foo"
    post_body.class.should == test_post_body.class
  end

  it "should have all needed keys in Hash from create_post_hash" do
    post_hash = @autoingestion.create_post_hash
    post_hash.should_not == nil
    post_hash.should have_key('USERNAME')
    post_hash.should have_key('REPORTTYPE')
    post_hash.should have_key('PASSWORD')
    post_hash.should have_key('VNDNUMBER')
    post_hash.should have_key('TYPEOFREPORT')
    post_hash.should have_key('DATETYPE')
    post_hash.should have_key('REPORTDATE')
  end

  it "should have proper number of entries in data from create_post_body" do
    post_body = @autoingestion.create_post_body
    post_body.should_not be_empty
    post_body.count("&").should == 6
  end

  it "should return proper values in Hash from create_post_hash" do
    @autoingestion.instance_variable_set :@username, "username"
    @autoingestion.instance_variable_set :@password, "password"
    @autoingestion.instance_variable_set :@vendor_number, "vendor_number"
    @autoingestion.instance_variable_set :@type_of_report, "type_of_report"
    @autoingestion.instance_variable_set :@date_type, "date_type"
    @autoingestion.instance_variable_set :@report_type, "report_type"
    @autoingestion.instance_variable_set :@report_date, "report_date"

    @autoingestion.create_post_hash['USERNAME'].should == "username"
    @autoingestion.create_post_hash['PASSWORD'].should == "password"
    @autoingestion.create_post_hash['VNDNUMBER'].should == "vendor_number"
    @autoingestion.create_post_hash['TYPEOFREPORT'].should == "type_of_report"
    @autoingestion.create_post_hash['DATETYPE'].should == "date_type"
    @autoingestion.create_post_hash['REPORTTYPE'].should == "report_type"
    @autoingestion.create_post_hash['REPORTDATE'].should == "report_date"
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
