class  Addition
  def initialize(*_args)
    @add = Proc.new { |args| args.reduce(:+) }
  end
  
  def add(*args)
    @add.call(args)  
  end
end  
    