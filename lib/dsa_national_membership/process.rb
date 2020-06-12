require "csv"
require_relative "member"

module DsaNationalMembership
  class Process
    attr_reader :members

    def initialize(filename, changes_filename, dest_filename)
      @filename = filename
      @changes_filename = changes_filename
      @dest_filename = dest_filename
      @members = {}
    end

    def diff(old_process)
      added_member_ak_ids = members.keys - old_process.members.keys
      removed_member_ak_ids = old_process.members.keys - members.keys
      changed_members = {}
      (members.keys & old_process.members.keys).each do |ak_id|
        member_diff = old_process.members[ak_id].diff(members[ak_id], changed_phone_numbers)
        if member_diff != {}
          changed_members[ak_id] = member_diff
        end
      end

      { added_members:   members.values.select{|member| added_member_ak_ids.include?(member.ak_id)}.map{|member| [member.ak_id, member]}.to_h,
        removed_members: old_process.members.values.select{|member| removed_member_ak_ids.include?(member.ak_id)}.map{|member| [member.ak_id, member]}.to_h,
        changed_members: changed_members
      }
    end

    def process
      in_header = true
      CSV.open(@dest_filename, "w") do |out|
        CSV.foreach(@filename) do |row|
          member = DsaNationalMembership::Member.new(row)
          if in_header
            out << member.transformed_header
            in_header = false
          else
            destination_row = member.destination_row(changed_phone_numbers)
            @members[member.ak_id] = member
            out << destination_row
          end
        end
      end
    end

    def changed_phone_numbers
      return @changed_phone_numbers if @changed_phone_numbers
      if @changes_filename
        set_changed_numbers
        @changed_phone_numbers
      else
        {}
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

