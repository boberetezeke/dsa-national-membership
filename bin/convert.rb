require_relative "../lib/process"

filename = ARGV.first
extension = File.extname(filename)
dest_filename = File.basename(filename, extension) + "-new.csv"
DsaNationalMembership::Process.new(filename, dest_filename).process