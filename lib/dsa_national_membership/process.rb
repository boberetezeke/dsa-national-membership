require "csv"
require_relative "member"

module DsaNationalMembership
  class Process
    def initialize(filename, changes_filename, dest_filename)
      @filename = filename
      @changes_filename = changes_filename
      @dest_filename = dest_filename
    end

    def process
      set_changed_numbers
      in_header = true
      CSV.open(@dest_filename, "w") do |out|
        CSV.foreach(@filename) do |row|
          member = DsaNationalMembership::Member.new(row)
          if in_header
            out << member.transformed_header
            in_header = false
          else
            out << member.destination_row(@changed_phone_numbers)
          end
        end
      end
    end

    def set_changed_numbers
      in_header = true
      @changed_phone_numbers = {}
      CSV.foreach(@changes_filename) do |row|
        if in_header
          row.each_with_index do |col, index|
            val = col&.downcase
            if val == "wrong number"
              @wrong_number_column_index = index
            elsif val == "ak id"
              @ak_id_index = index
            end
          end
          in_header = false
        else
          number = row[@wrong_number_column_index]&.strip
          unless number.nil?
            @changed_phone_numbers[number] = row[@ak_id_index]
          end
        end
      end
    end
  end
end

