require 'colorize'
class FileReader
  attr_reader :error_msg, :file_lines, :path, :file_lines_count
  def initialize(path)
    @error_msg = ''
    @path = path
    begin
      @file_lines = File.readlines(@path)
      @file_lines_count = @file_lines.size
    rescue StandardError => e
      @file_lines = []
      @error_msg = "Please verify filename or path provide:\n".colorize(:light_red) + e.to_s.colorize(:red)
    end
  end
end
