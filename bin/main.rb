#!/usr/bin/env ruby
require_relative '../lib/get_offence.rb'

investigation = GetOffence.new(ARGV.first)
investigation.investigate

if investigation.offences.empty? and investigation.detective.error_msg.empty?
  puts 'No offense'.colorize(:green) + ' detected'
else
  word = investigation.offences.length.equal?(1) ? 'offence' : 'offences'
  puts "#{investigation.offences.length} #{word}".colorize(:red) + ' detected'
  investigation.offences.uniq.each do |error|
    puts "#{investigation.detective.path.colorize(:cyan)} : #{error}"
  end
end
