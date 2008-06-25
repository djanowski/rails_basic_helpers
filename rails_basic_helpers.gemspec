Gem::Specification.new do |s|
  s.name = 'rails_basic_helpers'
  s.version = '0.0.1'
  s.summary = %{rails_basic_helpers}
  s.description = %{}
  s.date = %q{2008-06-25}
  s.author = "Damian Janowski"
  s.email = "damian.janowski@gmail.com"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.files = FileList['lib/**/*.rb', 'README', 'doc/**/*.*']
  s.require_paths << 'lib'
  
  FileList['lib/**'].inject(s.require_paths) do |require_paths,path|
    require_paths << path if File.directory?(path) && !require_paths.include?(path)
    require_paths
  end

  s.require_paths.uniq!
  
  s.extra_rdoc_files = ["README"]
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "rails_basic_helpers", "--main", "README"]
end
