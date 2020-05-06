require "csv"
require_relative "member"

module DsaNationalMembership
  class Process
    def initialize(filename, dest_filename)
      @filename = filename
      @dest_filename = dest_filename
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
            out << member.destination_row
          end
        end
      end
    end
  end
end

