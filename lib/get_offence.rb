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

  def detect_bad_file_name
    msg = 'Bad file name: Use snake_case for naming files.'
    @offences << msg.to_s unless @detective.path.match?(@snake_case)
  end

  def detect_proc_new_usage
    msg = 'Use `proc` instead of `Proc.new`.'
    regex = /Proc.new/
    @detective.file_lines.each_with_index do |line, index|
      @offences << line_position(line, index, regex) + msg.to_s if line.match?(regex)
    end
  end

  def detect_leading_empty_lines
    msg = 'Leading empty lines detected at beginning of file.'
    @offences << msg.to_s if @detective.file_lines[0].match?(/^(?:[\t ]*(?:\r?\n|\r))+/)
  end

  def detect_source_file_too_long
    msg = 'Source file too long, total lines should be < 100.'
    @offences << msg.to_s if @detective.file_lines_count > 100
  end

  def detect_trailing_empty_lines
    msg = 'Trailings empty lines at EOF, only one empty line expected at end of file.'
    if !@detective.file_lines.last.match?(/\S/) &&
       !@detective.file_lines[-1].gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(/\bend\b/)
      @offences << msg.to_s
    end
  end

  def detect_bad_comment_syntax
    msg = 'Bad comment syntax.'
    @detective.file_lines.each_with_index do |line, index|
      if line[0] == '#' and !line.match?(@good_comment)
        @offences << line_position(line, index, /\A#+[^#\s=:+-]/) + msg.to_s
      end
    end
  end

  def detect_trailing_spaces
    msg = 'Trailing whitespace detected.'
    regex = /\s{1,}\n/
    @detective.file_lines.each_with_index do |line, index|
      @offences << line_position(line, index, regex) + msg.to_s if line.match?(regex)
    end
  end

  def detect_double_spaces
    msg = 'Double spaces detected.'
    regex = /.+[\w]\s\s.+/
    @detective.file_lines.each_with_index do |line, index|
      @offences << line_position(line, index, regex) + msg.to_s if line.match?(regex)
    end
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
