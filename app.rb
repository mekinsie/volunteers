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

get('/projects') do
  @projects = Project.all
  erb(:projects)
end

post('/projects') do
  project = Project.new({:title => params[:title]})
  project.save
  @projects = Project.all
  erb(:projects)
end

get('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @volunteers = @project.volunteers
  erb(:project)
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i)
  erb(:project_edit)
end

patch('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @project.update({:title => params[:title]})
  @volunteers = @project.volunteers
  erb(:project)
end

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

get('/projects/:id/volunteers') do
  @project = Project.find(params[:id].to_i)
  @volunteers = @project.volunteers
  erb(:project)
end

get('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunteer_id].to_i)
  @project = Project.find(params[:id].to_i)
  erb(:volunteer)
end

patch('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunteer_id].to_i)
  @project = Project.find(params[:id].to_i)
  @volunteer.update({:name => params[:name]})
  erb(:volunteer)
end

delete('/projects/:id/volunteers/:volunteer_id') do
  @project = Project.find(params[:id].to_i)
  Volunteer.find(params[:volunteer_id].to_i).delete
  @volunteers = @project.volunteers
  erb(:project)
end

get('/volunteers') do
  @volunteers = Volunteer.all
  erb(:volunteers)
end