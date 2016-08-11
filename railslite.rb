#!/usr/bin/env ruby
require 'fileutils'
require 'active_support/inflector'


name = __FILE__
index = name.index("railslite.rb")
SKELETON_SOURCE = name[0...index] + "railslite_skeleton"

if ARGV[0] == "new"
  @target = ENV["PWD"] + "/" + ARGV[1]
  puts "Creating new Directory..."
  Dir.mkdir(@target)
  puts "Directory Created!"
  FileUtils.copy_entry SKELETON_SOURCE, @target
  puts "Generating project scaffold"
  File.open(@target + "/" + ARGV[1] + ".db", "w")
  puts "Scaffold Generated"
  puts "New RailsLite App Created!"
  FileUtils.chmod("+x", @target + "/lib/server.rb")
  exit
end

abort("You must be in the root directory of a railslite app to run this command!") unless File.exist?(ENV["PWD"] + "/config/.railslite")

def create_migration(name)
  puts "Generating #{name} migration..."
  file_name = ENV["PWD"] + "/db/migrate/" + Time.now.strftime("%y%m%d%I%M") + name + ".rb"
  table_name = :table_name
  if name.split("_").first == "create"
    table_name = name.split("_").last
  end
  File.open(file_name, "w") do |f|
    f.write("create_table :#{table_name} do |t|\n  \nend")
  end
  puts "#{name} migration generated!"
end

case ARGV[0]
when "s" || "server"
  @target = ENV["PWD"] + "/lib/server.rb"
  system "ruby " + @target
when "migrate"
  @target = ENV["PWD"] + "/lib/migrate.rb"
  system "ruby " + @target
when "g" || "generate"
  @target = ENV["PWD"] + "/app"
  case ARGV[1]
  when "model"
    puts "Generating #{ARGV[2]} model..."
    File.open(@target + "/models/" + ARGV[2].singularize.underscore + ".rb", "w") do |f|
      f.write("class #{ARGV[2].singularize.camelize} < ModelBase\n\n  # DO NOT REMOVE\n  finalize!\nend")
    end
    puts "#{ARGV[2]} model generated!"
    create_migration("create_" + ARGV[2].pluralize.underscore)
  when "controller"
    puts "Generating #{ARGV[2]} controller..."
    name = (ARGV[2] + "Controller").underscore
    Dir.mkdir @target + "/views/" + ARGV[2].downcase
    File.open(@target + "/controllers/" + name + ".rb", "w") do |f|
      f.write("class #{ARGV[2].camelize + "Controller"} < ControllerBase\n\nend")
    end
    puts "#{ARGV[2]} controller generated!"
  when "migration"
    create_migration(ARGV[2].underscore)
  end
end
