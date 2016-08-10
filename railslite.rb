#!/usr/bin/env ruby
require 'fileutils'
require 'active_support/inflector'


name = __FILE__
index = name.index("railslite.rb")
SKELETON_SOURCE = name[0...index] + "railslite_skeleton"

if ARGV[0] == "new"
  @target = ENV["PWD"] + "/" + ARGV[1]
  Dir.mkdir(@target)
  FileUtils.copy_entry SKELETON_SOURCE, @target
  File.open(@target + "/" + ARGV[1] + ".db", "w")
  FileUtils.chmod("+x", @target + "/lib/server.rb")
  exit
end

abort("You must be in the root directory of a railslite app to run this command!") unless File.exist?(ENV["PWD"] + "/config/.railslite")

case ARGV[0]
when "s" || "server"
  @target = ENV["PWD"] + "/lib/server.rb"
  system "ruby " + @target
when "g" || "generate"
  @target = ENV["PWD"] + "/app"
  case ARGV[1]
  when "model"
    File.open(@target + "/models/" + ARGV[2].singularize.underscore + ".rb", "w") do |f|
      f.write("class #{ARGV[2].singularize.camelize} < ModelBase\n\n  # DO NOT REMOVE\n  finalize!\nend")
    end
  when "controller"
    name = (ARGV[2] + "Controller").underscore
    Dir.mkdir @target + "/views/" + ARGV[2].downcase
    File.open(@target + "/controllers/" + name + ".rb", "w") do |f|
      f.write("class #{ARGV[2].camelize + "Controller"} < ControllerBase\n\nend")
    end
  end
end
