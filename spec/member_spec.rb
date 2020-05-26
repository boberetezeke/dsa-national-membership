require "spec_helper"
require "csv"
require_relative "../lib/dsa_national_membership/member"

describe DsaNationalMembership::Member do
  let(:header_row) {
    'AK_ID,DSA_ID,first_name,middle_name,last_name,suffix,Organization,Address_Line_1,Address_Line_2,City,State,Zip,Country,Mobile_Phone,Home_Phone,Work_Phone,afafd,Mail_preference,Do_Not_Call,Join_Date,Xdate,Memb_status,membership_type,monthly_status,chapter,membership_status'
  }
  let(:row) {
    '1234,5678,Bob,B,Retezeke,,,1616 Drury Lane,,St. Paul,MN,88111-2318,United States,363-212-1181,"363-211-1181, 3632111181, 363-2111181",,kbakejae.drkfjnfae@gfafd.daf,Yes,FALSE,2/1/17,2/11/21,M,annual,never,Twin Cities,member in good standing'
  }
  subject   { described_class.new(CSV.parse(row).first)}

  describe "#initialize" do
    it "loads the first_name field" do
      expect(subject.first_name).to eq("Bob")
    end

    it "loads the last_name field" do
      expect(subject.last_name).to eq("Retezeke")
    end

    it "loads the country field" do
      expect(subject.country).to eq("United States")
    end

    it "loads the mobile phone field" do
      expect(subject.mobile_phone).to eq("363-212-1181")
    end

    it "loads the home phone field" do
      expect(subject.home_phone).to eq("363-211-1181, 3632111181, 363-2111181")
    end

    it "loads the work phone field" do
      expect(subject.work_phone).to eq(nil)
    end

    it "join date" do
      expect(subject.join_date).to eq("2/1/17")
    end

    it "membership status" do
      expect(subject.membership_status).to eq("member in good standing")
    end
  end

  describe "#diff" do
    let(:changed_row) {
      '1234,5678,Bob,B,Retezeke,,,1717 Drury Lane,,St. Paul,MN,88111-2318,United Slates,363-212-1181,"363-211-1182, 3632111182, 363-2111182",,kbakejae.drkfjnfae@gfafd.daf,Yes,FALSE,2/1/17,2/11/21,M,annual,never,Twin Cities,member in good standing'
    }
    let(:changed_member)   { described_class.new(CSV.parse(changed_row).first)}

    it "detects difference on non-phone columns" do
      expect(changed_member.diff(subject, {})).to eq({
        address_line_1: {old_value: "1616 Drury Lane", new_value: "1717 Drury Lane"},
        country: {old_value: "United States", new_value: "United Slates"},
        phone_numbers: {added_numbers: ["3632111182"], removed_numbers: ["3632111181"]}
      })
    end
  end

  describe "#destination_phone_numbers" do
    context "with no wrong numbers" do
      it "creates two destination phone numbers" do
        expect(subject.destination_phone_numbers({}).size).to eq(2)
      end

      it "creates an output line with the phone numbers removed and the destination numbers added to the end" do
        expect(subject.destination_row({})).to eq(
          [
            '1234','5678','Bob','B','Retezeke',nil,nil,'1616 Drury Lane',
            nil,'St. Paul','MN','88111-2318','United States',
            'kbakejae.drkfjnfae@gfafd.daf','Yes','FALSE',
            '2/1/17','2/11/21','M','annual','never','Twin Cities','member in good standing',
            '3632111181','3632121181'
          ]
        )
      end
    end

    context "with a wrong number for this member" do
      let(:changed_phone_numbers) { {"3632111181" => "1234"} }

      it "creates two destination phone numbers" do
        expect(subject.destination_phone_numbers(changed_phone_numbers).size).to eq(1)
      end

      it "creates an output line with the phone numbers removed and the destination numbers added to the end" do
        expect(subject.destination_row(changed_phone_numbers)).to eq(
           [
             '1234','5678','Bob','B','Retezeke',nil,nil,'1616 Drury Lane',
             nil,'St. Paul','MN','88111-2318','United States',
             'kbakejae.drkfjnfae@gfafd.daf','Yes','FALSE',
             '2/1/17','2/11/21','M','annual','never','Twin Cities','member in good standing',
             '3632121181'
           ]
         )
      end
    end

    context "with a wrong number for a different member" do
      let(:changed_phone_numbers) { {"3632111181" => "1235"} }

      it "creates two destination phone numbers" do
        expect(subject.destination_phone_numbers(changed_phone_numbers).size).to eq(2)
      end

      it "creates an output line with the phone numbers removed and the destination numbers added to the end" do
        expect(subject.destination_row(changed_phone_numbers)).to eq(
          [
           '1234','5678','Bob','B','Retezeke',nil,nil,'1616 Drury Lane',
           nil,'St. Paul','MN','88111-2318','United States',
           'kbakejae.drkfjnfae@gfafd.daf','Yes','FALSE',
           '2/1/17','2/11/21','M','annual','never','Twin Cities','member in good standing',
           '3632111181','3632121181'
          ]
        )
      end
    end
  end

  describe ".transformed_header" do
    it "transforms the header" do
      expect(described_class.new(CSV.parse(header_row).first).transformed_header).to eq(
        ['AK_ID','DSA_ID','first_name','middle_name','last_name','suffix','Organization','Address_Line_1','Address_Line_2',
         'City','State','Zip','Country','afafd','Mail_preference','Do_Not_Call','Join_Date',
         'Xdate','Memb_status','membership_type','monthly_status','chapter','membership_status',
         'Phone-1','Phone-2','Phone-3','Phone-4','Phone-5','Phone-6','Phone-7'
        ]
      )
    end
  end
end