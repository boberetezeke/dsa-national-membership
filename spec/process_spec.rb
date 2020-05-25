require 'spec_helper'

require_relative "../lib/dsa_national_membership/process"

describe Process do
  let(:header_row) {
    'AK_ID,DSA_ID,first_name,middle_name,last_name,suffix,Organization,Address_Line_1,Address_Line_2,City,State,Zip,Country,Mobile_Phone,Home_Phone,Work_Phone,afafd,Mail_preference,Do_Not_Call,Join_Date,Xdate,Memb_status,membership_type,monthly_status,chapter,membership_status'
  }
  let(:row) {
    '1234,5678,Bob,B,Retezeke,,,1616 Drury Lane,,St. Paul,MN,88111-2318,United States,363-212-1181,"363-211-1181, 3632111181, 363-2111181",,kbakejae.drkfjnfae@gfafd.daf,Yes,FALSE,2/1/17,2/11/21,M,annual,never,Twin Cities,member in good standing'
  }
  let(:row_2) {
    '2345,5679,Michael,P,Brooks,,,123 Grand Lane,,St. Paul,MN,55512,United States,651-111-2222,"612-111-2222, 651-111-2222",,kbakejae.drkfjnfae@gfafd.daf,Yes,FALSE,2/1/17,2/11/21,M,annual,never,Twin Cities,member in good standing'
  }

  let(:changes_header_row) {
    'AK ID,Last Name,First Name,Do not call,Do not text,Do not email,Unsubscribed email,Wrong number,Moved,Date added,Contact type,Contacted by,Note,Updated in member list'
  }
  let(:changes_row) {
    '2345,Brooks,Michael,,,TRUE,,6511112222,,11/5/2019,,,,Yes'
  }

  before do
    File.open("spec/input.csv", "w") {|f| f.puts(header_row); f.puts(row); f.puts(row_2) }
    File.open("spec/changes.csv", "w") {|f| f.puts(changes_header_row); f.puts(changes_row) }
    DsaNationalMembership::Process.new("spec/input.csv", "spec/changes.csv",  "spec/output.csv").process
    @lines = CSV.read("spec/output.csv")
  end

  after do
    File.unlink("spec/input.csv")
      # File.unlink("spec/output.csv")
  end

  describe "#process" do
    it "generates a header line and value line" do
      expect(@lines.size).to eq(3)
    end

    it "generates a phone 1 column header" do
      expect(@lines[0][23]).to eq("Phone-1")
    end

    it "generates a phone 2 column header" do
      expect(@lines[0][24]).to eq("Phone-2")
    end

    it "generates a phone value for the member 1 phone 1 column" do
      expect(@lines[1][23]).to eq("3632111181")
    end

    it "generates a phone value for the member 1 phone 2 column" do
      expect(@lines[1][24]).to eq("3632121181")
    end

    it "generates a phone value for the member 2 phone 1 column" do
      expect(@lines[2][23]).to eq("6121112222")
    end

    it "generates a phone value for the member 2 phone 2 column" do
      expect(@lines[2][24]).to eq(nil)
    end
  end

  describe "#process" do

  end
end