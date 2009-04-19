# Git template.
log 'template', 'Applying git template'

begin
  raise ScriptError, "This application is already using git." if File.exists?('.git/config')
rescue ScriptError => e
  puts e.message
  Kernel::exit(1)
end

unless self.respond_to?(:root_config)
  @stand_alone = true
  load_template('http://github.com/hectoregm/groundwork/raw/master/methods.rb')
end

# Remove tmp directories
%w[tmp/pids tmp/sessions tmp/sockets tmp/cache].each do |dir|
  rmdir dir
end

# Delete unnecessary files.
%w[doc/README_FOR_APP public/index.html public/favicon.ico public/robots.txt config/locales/en.yml].each do |file|
  rm file
end

# Hold empty directories making a .gitignore file
run("find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;", false)

# Copy database.yml for distribution use
cp 'config/database.yml', 'config/database.yml.example'

# Create  master .gitignore file
root_config '.gitignore'

# Initialize git repository
git :init

if @stand_alone
  # Send initial commit
  git :add => "."
  git :commit => "-a -m 'Setting up git repository'"
end

log 'template', 'Successfully applied git template'
