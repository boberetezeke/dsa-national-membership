require_relative "../lib/dsa_national_membership/process"

filename = ARGV.first
if filename
  extension = File.extname(filename)
  dest_filename = File.basename(filename, extension) + "-new.csv"
  DsaNationalMembership::Process.new(filename, dest_filename).process
else
  puts "USAGE: #{$0} filename.csv"
end


