module DsaNationalMembership
  class Member
    NUM_PHONES = 7
    SYMS = [:ak_id, :dsa_id, :first_name, :middle_name, :last_name, :suffix,
            :organization, :address_line_1, :address_line_2, :city, :state, :zip, :country,
            :mobile_phone, :home_phone, :work_phone, :afdfd, :mail_preference, :do_not_call,
            :join_date, :x_date, :memb_status, :membership_type, :monthly_status, :chapter, :membership_status]
    attr_accessor *SYMS

    def initialize(row)
      SYMS.each_with_index do |sym, index|
        self.send("#{sym}=", row[index])
      end
    end

    def destination_row(changed_phone_numbers)
      row = []
      row_minus_phones(row)

      destination_phone_numbers(changed_phone_numbers).sort.each do |destination_phone|
        row.push(destination_phone)
      end

      row
    end

    def destination_phone_numbers(changed_phone_numbers)
      [@mobile_phone, @work_phone, @home_phone, @work_phone].inject([]) do |sum, phone_numbers_as_string|
        phone_numbers = split_phone_numbers(phone_numbers_as_string)
        phone_numbers.each do |phone_number|
          possible_wrong_number_ak_id = changed_phone_numbers[phone_number]
          if possible_wrong_number_ak_id.nil? || possible_wrong_number_ak_id != @ak_id
            sum = sum + [phone_number] unless sum.include?(phone_number)
          end
        end

        sum
      end
    end

    def split_phone_numbers(phone_numbers_string)
      return [] if phone_numbers_string.nil?
      phone_numbers_string.split(/,/).map(&:strip).map{|phone_number| normalize_phone_number(phone_number)}
    end

    def normalize_phone_number(phone_number)
      phone_number.gsub(/[^\d]/, "")
    end

    def transformed_header
      row = []
      row_minus_phones(row)

      (1..NUM_PHONES).to_a.each do |phone_index|
        row.push("Phone-#{phone_index}")
      end

      row
    end

    private

    def row_minus_phones(row)
      (SYMS - [:mobile_phone, :home_phone, :work_phone]).each do |sym|
        row.push(self.send(sym))
      end
    end
  end
end
