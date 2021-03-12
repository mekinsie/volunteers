class Project
  attr_accessor :title
  attr_reader :id


  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(project_to_compare)
    if project_to_compare != nil
      (self.title == project_to_compare.title)
    end
  end

  def self.all
    projects = []
    returned_projects = DB.exec("SELECT * FROM projects;")
    returned_projects.each do |project|
      title = project.fetch('title')
      id = project.fetch('id')
      projects.push(Project.new({:title => title, :id => id}))
    end
    projects
  end

end