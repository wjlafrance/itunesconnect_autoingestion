require 'util/http_verify_none.rb'
require 'net/https'
require 'uri'
require 'cgi'

def main
  autoingestor = Autoingestion.new
  yesterday = (Time.new - 24*60*60).strftime("%Y%m%d")

  if File.exists?("config.hash")
    config = eval(File.new("config.hash").read())
    autoingestor.username = config["username"]
    autoingestor.password = config["password"]
    autoingestor.vendor_number = config["vendor_number"]
  else
    print "iTunes Connect email address:             "
    autoingestor.username = gets.strip!
    print "iTunes Connect password:                  "
    autoingestor.password = gets.strip!
    print "Vendor number:                            "
    autoingestor.vendor_number = gets.strip!
    print "Type of report:                [Sales]    "
    autoingestor.type_of_report = gets.strip!
    print "Date type:                     [Daily]    "
    autoingestor.date_type = gets.strip!
    print "Report type:                   [Summary]  "
    autoingestor.report_type = gets.strip!
    print "Report date:                   [#{yesterday}] "
    autoingestor.report_date = gets.strip!
  end

  autoingestor.type_of_report = "Sales"   if autoingestor.type_of_report.empty?
  autoingestor.date_type      = "Daily"   if autoingestor.date_type.empty?
  autoingestor.report_type    = "Summary" if autoingestor.report_type.empty?
  autoingestor.report_date    = yesterday if autoingestor.report_date.empty?

  autoingestor.perform_request
end

class Autoingestion

  ITUNES_URL = "https://reportingitc.apple.com/autoingestion.tft"

  attr_accessor :username
  attr_accessor :password
  attr_accessor :vendor_number
  attr_accessor :type_of_report
  attr_accessor :date_type
  attr_accessor :report_type
  attr_accessor :report_date

  def create_post_body
    data  = "USERNAME="     + CGI.escape(@username.to_s)       + "&"
    data += "PASSWORD="     + CGI.escape(@password.to_s)       + "&"
    data += "VNDNUMBER="    + CGI.escape(@vendor_number.to_s)  + "&"
    data += "TYPEOFREPORT=" + CGI.escape(@type_of_report.to_s) + "&"
    data += "DATETYPE="     + CGI.escape(@date_type.to_s)      + "&"
    data += "REPORTTYPE="   + CGI.escape(@report_type.to_s)    + "&"
    data += "REPORTDATE="   + CGI.escape(@report_date.to_s)
  end

  def perform_request
    uri = URI.parse(ITUNES_URL)
    
    request = Net::HTTP.new(uri.host, uri.port)
    request.use_ssl = true
    
    body = create_post_body
    headers = {'Content-Type' => 'application/x-www-form-urlencoded'}
    response = request.post2(uri.path, body, headers)

    if response['filename'] != nil
      filename = response['filename']
      f = File.new(filename, "w")
      f.write(response.body)
      f.close
      puts "File Downloaded Successfully (#{filename})"

      system("cp #{filename} #{filename}.bak")
      system("gunzip #{filename}")
      system("mv #{filename}.bak #{filename}")
      
    elsif response['errormsg'] != nil
      puts response['errormsg']
    else
      puts "No recognized response, dumping headers.."
      response.each_header do | key, value |
        puts "#{key}: #{value}"
      end
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  main
end
