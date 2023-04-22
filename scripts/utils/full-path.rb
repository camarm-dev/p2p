# This script replace every './' in require statement by th PATH of every file of directory [dir] (first arg)

PATH = '/usr/lib/p2p/'

def replace_path_in(files=[])
  files.each do |file|
    content = File.read(file)
    content = content.gsub("require './", "require '#{PATH}")
    File.write(file, content)
  end
end

def list_files_in(directory)
  return Dir["#{directory}/**/*.rb"]
end


files = list_files_in(ARGV[0])
replace_path_in(files)
