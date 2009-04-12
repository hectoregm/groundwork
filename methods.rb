# Convenience Methods
def get_root(relative_destination)
  base_dir = ENV['BASE_PATH'] || "http://github.com/hectoregm/rails-templates/raw/master/base"
  File.join(base_dir, relative_destination)
end

def apply_template(name)
  load_template(get_root("../#{name.to_s}.rb"))
end

def app_name
  File.basename(@app_dir).capitalize
end

def cp(source, destination)
  log 'cp', source
  run("cp #{source} #{destination}", false)
end

def cp_r(source, destination)
  log 'cp_r', source
  run("cp -Rp #{get_root(source)} #{destination}", false)
end

def rm(filename)
  log 'rm', filename
  run("rm #{filename}", false)
end

def rmdir(dir)
  log 'rmdir', dir
  run("rmdir #{dir}", false)
end

def get_source(relative_destination)
  destination = get_root(relative_destination)
  ouput = open(destination, 'r') { |file| file.read }
end

def root_config(filename)
  log 'config', filename
  file(filename, get_source(filename), false)
end

def spec(filename)
  log 'spec', filename
  file("spec/#{filename}", get_source("spec/#{filename}"), false)
end

def feature(filename)
  log 'feature', filename
  file("features/#{filename}", get_source("features/#{filename}"), false)
end

def model(filename)
  log 'model', filename
  file("app/models/#{filename}", get_source("app/models/#{filename}"), false)
end

def controller(filename)
  log 'controller', filename
  file("app/controllers/#{filename}", get_source("app/controllers/#{filename}"), false)
end

def helper(filename)
  log 'helper', filename
  file("app/helpers/#{filename}", get_source("app/helpers/#{filename}"), false)
end

def view(controller, filename)
  log 'view', "#{filename} for #{controller}"
  file("app/views/#{controller}/#{filename}", get_source("app/views/#{controller}/#{filename}"), false)
end

def layout(filename)
  log 'layout', filename
  file("app/views/layouts/#{filename}", get_source("app/views/layouts/#{filename}"), false)
end
