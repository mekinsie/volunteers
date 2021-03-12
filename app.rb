require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
require('pg')
also_reload('lib/**/*.rb')
DB = PG.connect({:dbname => "volunteer_tracker", :password => 'bean'})

get('/')do
  erb(:home)
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
  @project = Project.find(params[:id])
  erb(:project)
end

patch('/projects/:id') do
  @project = Project.find(params[:id])
  @project.update({:title => params[:title]})
  erb(:project)
end

delete('/projects/:id') do
  Project.find(params[:id]).delete
  @projects = Project.all
  erb(:projects)
end

# Volunteers

get('/projects/:id/volunteers') do
  @volunteers = Volunteers.all
  erb(:volunteers)
end

get('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunteer_id])
  erb(:volunteer)
end

patch('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunter_id])
  project = Project.find(params[:id])
  @volunteer.update({:name => params[:name], :project_id => project})
  erb(:volunteer)
end

delete('/projects/:id/volunteers/:volunteer_id') do
  Volunteer.find(params[:volunteer_id]).delete
  @Volunteers = Volunteer.all
  erb(:volunteers)
end