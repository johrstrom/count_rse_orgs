#!/usr/bin/env ruby

require 'yaml'
require 'csv'

aliases = YAML.safe_load(File.read("#{__dir__}/alias_map.yml"))
              .map do |org, org_aliases|
                [org, org_aliases.map { |a| a.to_s.downcase }]
              end.to_h

input_file = ARGV.first.to_s
abort('You need to specify a file to read in $1') if input_file.empty?

lines = File.read(input_file).each_line.map do |line|
  line = line.to_s.chomp.downcase
  aliases.map do |org, org_aliases|
    [org, 1] if org_aliases.include?(line) || org.downcase == line
  end.compact
end.reject do |arr|
  arr.empty?
end.each_with_object(Hash.new(0)) do |count, res|
  count = count.flatten
  res[count.first] = res[count.first] + 1
end.each do |org, count|
  puts "#{org}: #{count}"
end
