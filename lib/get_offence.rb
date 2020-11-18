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
end
