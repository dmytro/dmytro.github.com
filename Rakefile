require 'highline/import'
require 'erb'
require 'yaml'

task :test do 
  rspec spec
end

task :default => "blog:new_post"

namespace :blog do 

  directory "_posts"

  desc "Create template for new post"
  task :new_post => ["_posts", :read_template, :read_tags] do

    @title = ask "Post title: " || ''
    
    @post_tags = []
    catch :exit do
      loop do 
        choose do |menu|
          menu.header = "Select form available tags or add new"
          menu.prompt = "   Selected: #{@post_tags.join ', '}"
          menu.choices(*(@tags-@post_tags).sort.map(&:to_sym)) { |t| @post_tags << t.to_s }
          menu.choice("  >>> Enter new tag") do
            @post_tags << ask("New tag: ")
          end
          menu.choice("  >>> End selection") {  throw :exit }
        end
      end
    end

    @summary = ask "Post summary: "
    @description = ask "Post description: "
    
    filename = Time.now.strftime "_posts/%Y-%m-%d-#{@title.downcase.gsub(/\s+/, '_')}.md"

    file = File.open filename, 'w'
    file.print @template.result(binding)
    file.close
    say "Created file #{filename}"
  end

  task:read_template do 
    @template = ERB.new(File.read("_posts/template.md.erb"), nil,'%<>-')
  end

  task :read_tags do 
    tags = []
    Dir.glob("_posts/20*").each do |f|
      tags << YAML.load_file(f)['tags']
    end
    @tags = tags.flatten.uniq.compact!
  end
end


