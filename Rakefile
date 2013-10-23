require 'highline/import'
require 'erb'
require 'yaml'
require 'date'

desc "Run rspec tests"
task :test do 
  sh "rspec spec"
end

namespace :images do

  MAX_GEOMETRY = { 
    w: 1280.0, 
    h: 960.0
  }


  def resize name, w, h
    sh %{mogrify -resize #{MAX_GEOMETRY[:w]}x#{MAX_GEOMETRY[:h]} '#{name}'}
  end

  namespace :jpeg do 
    task :list do 
      @jpgs = Dir.glob("**/*.jpg") - Dir.glob("_site/**/*.jpg")
    end

    desc "Scale down images to max geometry allowed"
    task :resize => :list do 
      files= { }

      @jpgs.each do |jpg|
        IO.popen "identify '#{jpg}'" do |p|
          f = p.read
          name,bla,size = f.split(/ /)
          name.sub!(/jpg\[\d+\]$/, 'jpg')
          w,h = size.split('x').map(&:to_i)
          next unless name && w && h
          resize(name, w, h) if w > MAX_GEOMETRY[:w] || h > MAX_GEOMETRY[:h]
        end
      end
    end

    desc "Compress JPEG images"
    task :minimize => :list do 
      @jpgs.each do |f|
        sh "jpegoptim --strip-all --totals -o '#{f}'"
      end

    end

  end
  namespace :png do
    
    task :list do
      @pngs = Dir.glob("**/*.png") - Dir.glob("_site/**/*.png")
    end

    desc "Compress PNG images"
    task :minimize => :list do 
      @pngs.each do |png|
        before = File.size png
        sh "./bin/pngout #{png} -q | true"
        puts "#{png} : #{before - File.size(png)} bytes smaller "
      end

    end
  end
end

require 'fileutils'

desc "compile and publich the site to Github"
task :publish do
  sh "git checkout source"
  sh "scss --style compressed sass/dmytro.sass:css/dmytro.css sass/style.sass:css/style.css"
  sh "jekyll build"
  sh "jpegoptim --strip-all --totals -o _site/images/galleries/*-thumb*"
  sh "cd _site && git add -A && git commit -m \"Publishing at $(date)\" && git push origin master"
end

desc "compile and run the site locally"
task :run do
  pids = [
    spawn("jekyll serve --watch --drafts"), # put `auto: true` in your _config.yml
    spawn("scss --style compressed --watch sass/style.sass:css/style.css"),
#    spawn("scss --style compressed --watch sass/dmytro.sass:css/dmytro.css --watch sass/style.sass:css/style.css"),
#    spawn("coffee -b -w -o javascripts -c assets/*.coffee")
  ]
 
  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end
 
  loop do
    sleep 1
  end
end


task :default => "new:blog"

namespace :new do

  
  desc "Create template for new blog post"
  task :blog => ["_posts", "blog:title", :summary, :description, "blog:read_template", :tags, "blog:write"]

  desc "Create stub for new project file"
  task :project => ["project:name", :summary, :description, "project:read_template", :tags, "project:write"]



  namespace :project do
    task :read_template do 
      @template = ERB.new(File.read("template.md.erb"), nil,'%<>-')
    end
    task :name do 
      @name = ask "Project name: " || ''
    end

    task :write do
      filename = "#{@name.gsub(/\s+/,"_").downcase}.md"      
      file = File.open filename, 'w'
      file.print @template.result(binding)
      file.close
      say "Created file #{filename}"

    end
  end

  namespace :blog do 
    directory "_posts"

    task :read_template do 
      @template = ERB.new(File.read("_posts/template.md.erb"), nil,'%<>-')
    end
    task :title do 
      @title = ask "Post title: " || ''
    end

    task :write do
      filename = Time.now.strftime "_posts/%Y-%m-%d-#{@title.downcase.gsub(/\s+/, '_')}.md"      
      file = File.open filename, 'w'
      file.print @template.result(binding)
      file.close
      say "Created file #{filename}"

    end

  end

  # Asking user to enter tags
  task :tags => :read_tags do
    @tags = []
    catch :exit do
      loop do 
        choose do |menu|
          menu.header = "Select form available tags or add new"
          menu.prompt = "   Selected: #{@tags.join ', '}"
          menu.choices(*(@all_tags-@tags).sort.map(&:to_sym)) { |t| @tags << t.to_s }
          menu.choice("  >>> Enter new tag") do
            @tags << ask("New tag: ")
          end
          menu.choice("  >>> End selection") {  throw :exit }
        end
      end
    end

  end

  task :summary do
    @summary = ask "Summary: "
  end

  task :description do
    @description = ask "Description: "
  end


  task :read_tags do 
    tags = []
    Dir.glob("_posts/20*").each do |f|
      tags << YAML.load_file(f)['tags']
    end
    @all_tags = tags.flatten.uniq.compact!
  end
end


