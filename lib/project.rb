class Project
  attr_accessor :title
  attr_reader :id


  def initialize(attributes)
    @title = attributes[:title]
    @volunteer_id = attributes[:volunteer_id]
    @id = attributes[:id]
  end

end