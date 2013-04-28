require 'mkmf'
require 'ginatra'
require 'sprockets'
require 'git/webby'

git_executable = find_executable 'git'
raise 'Git executable not found in PATH' if git_executable.nil?

Git::Webby::HttpBackend.configure do |server|
  server.project_root = './repos'
  server.git_path     = git_executable
  server.get_any_file = true
  server.upload_pack  = false
  server.receive_pack = false
  server.authenticate = false
end

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'public/js'
  environment.append_path 'public/css'
  run environment
end

run Rack::Cascade.new [Git::Webby::HttpBackend, Ginatra::App]
