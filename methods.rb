# Convenience Methods
FEATURES = [:git, :bundler, :bdd, :authlogic]
TEMPLATING_ENGINE = "haml"

def get_base_path(relative_destination)
  base_dir = ENV['BASE_PATH'] || "http://github.com/hectoregm/groundwork/raw/master/base"
  File.join(base_dir, relative_destination)
end

def apply_template(name)
  load_template(get_base_path("../#{name.to_s}.rb"))
end

def app_name
  File.basename(Dir.pwd).capitalize
end

def requested?(feature)
  if ENV['FEATURES']
    ENV['FEATURES'].split.include?(feature.to_s)
  else
    FEATURES.include?(feature)
  end
end

def templating_engine
  ENV['TEMPLATING_ENGINE'] || TEMPLATING_ENGINE
end

def cp(source, destination)
  log 'cp', source
  run("cp #{source} #{destination}", false)
end

def cp_r(source, destination)
  log 'cp_r', source
  run("cp -Rp #{get_base_path(source)} #{destination}", false)
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
  destination = get_base_path(relative_destination)
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

def stylesheet(filename)
  log 'stylesheet', filename
  file("public/stylesheets/#{filename}", get_source("public/stylesheets/#{filename}"), false)
end

def sass(filename)
  log 'sass', filename
  file("public/stylesheets/sass/#{filename}", get_source("public/stylesheets/sass/#{filename}"), false)
end
