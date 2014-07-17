class User

  attr_accessor :name, :id, :tweets, :followers
  def initialize(*args)
    @id        = args[0]
    @name      = args[1]
    @tweets    = args[2] || []
    @followers = args[3] || []
  end
end
