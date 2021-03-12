class Project
  attr_accessor :title
  attr_reader :id


  def initialize(attributes)
    @title = attributes[:title]
    @volunteer_id = attributes[:volunteer_id]
    @id = attributes[:id]
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@id}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(project_to_compare)
    if project_to_compare != nil
      (self.title == project_to_compare.title)
    end
  end

end