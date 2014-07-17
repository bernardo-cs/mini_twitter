require_relative "../../data_parser/lib/data_parser.rb"
class Tweet

  attr_reader :id, :text, :trimmed_text
  def initialize(*args)
    @id   = args[0]
    @text = args[1]
  end

  def trimmed_text
    text.trim
  end
end
