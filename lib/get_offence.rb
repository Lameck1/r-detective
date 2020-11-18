require 'strscan'
require 'colorize'
require_relative 'reader.rb'
class GetOffence
  attr_reader :detective, :offences

  def initialize(path)
    @detective = FileReader.new(path)
    @offences = []
    @snake_case = /^[\d[[:lower:]]_.?!]+$/.freeze
    @camel_case = /^[A-Z][A-Za-z\d]+$/
    @good_comment = /\A#+ [^#\s=:+-]/.freeze
    @leading_space = /\A */
  end

  def report_offence(offence)
    @offences << offence
  end

  def line_position(line, index, regex)
    "line:#{index + 1}:#{line.index(regex)}: "
  end

  def investigate
    if @detective.file_lines.empty?
      puts "File under investigation `#{@detective.path}` is empty".colorize(:green)
    else
      detect_bad_comment_syntax
      detect_bad_file_name
      detect_proc_new_usage
      detect_trailing_empty_lines
      detect_source_file_too_long
      detect_leading_empty_lines
      detect_double_spaces
      detect_trailing_spaces
    end
  end
end
