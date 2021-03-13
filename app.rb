require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
require('pg')
also_reload('lib/**/*.rb')
DB = PG.connect({:dbname => "volunteer_tracker", :password => 'bean'})

get('/')do
  redirect "/projects"
end

# Projects
# See all projects
get('/projects') do
  @projects = Project.all
  erb(:projects)
end
# Add a project
post('/projects') do
  project = Project.new({:title => params[:title]})
  project.save
  @projects = Project.all
  erb(:projects)
end
#See a specific project and a list of its volunteers
get('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @volunteers = @project.volunteers
  erb(:project)
end
#Get the edit project form page
get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i)
  erb(:project_edit)
end
#Update a project title
patch('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @project.update({:title => params[:title]})
  @volunteers = @project.volunteers
  erb(:project)
end
#Delete a project
delete('/projects/:id') do
  Project.find(params[:id].to_i).delete
  @projects = Project.all
  erb(:projects)
end

# Volunteers
#Add volunteer to project
post('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  volunteer = Volunteer.new({:name => params[:name], :project_id => params[:id].to_i, :id => nil})
  volunteer.save
  @volunteers = @project.volunteers
  erb(:project)
end
# Read project page with list of volunteers
get('/projects/:id/volunteers') do
  @project = Project.find(params[:id].to_i)
  @volunteers = @project.volunteers
  erb(:project)
end
# See the page for a specific volunteer
get('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunteer_id].to_i)
  @project = Project.find(params[:id].to_i)
  erb(:volunteer)
end
#Update a volunteer's name
patch('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunteer_id].to_i)
  @project = Project.find(params[:id].to_i)
  @volunteer.update({:name => params[:name]})
  erb(:volunteer)
end
#Delete a volunteer
delete('/projects/:id/volunteers/:volunteer_id') do
  @project = Project.find(params[:id].to_i)
  Volunteer.find(params[:volunteer_id].to_i).delete
  @volunteers = @project.volunteers
  erb(:project)
end
# See a list of all volunteers
get('/volunteers') do
  @volunteers = Volunteer.all
  erb(:volunteers)
end