class Volunteer
  attr_accessor :name, :project_id
  attr_reader :id

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
    @project_id = attributes[:project_id]
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{@name}', #{@project_id}) RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(volunteer_to_compare)
    if volunteer_to_compare != nil
      (self.name == volunteer_to_compare.name)
    else
      false
    end
  end

  def self.all
    volunteers = []
    returned_volunteers = DB.exec("SELECT * FROM volunteers;")
    returned_volunteers.each do |volunteer|
      name = volunteer.fetch('name')
      id = volunteer.fetch('id')
      project_id = volunteer.fetch('project_id')
      volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
    end
    volunteers
  end

  def self.find(id)
   volunteer = DB.exec("SELECT * FROM volunteers WHERE id = #{id};").first
    if volunteer != nil
      name = volunteer.fetch("name")
      id = volunteer.fetch("id")
      project_id = volunteer.fetch('project_id')
      Volunteer.new({:name => name, :project_id => project_id, :id => id})
    end
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id};")
    end
  end

  def delete
    DB.exec("DELETE FROM volunteers WHERE id = #{@id};")
  end
end