require 'thor'
require './lib/storage/utils'
require './lib/ansi'

SETTINGS = Storage::read('settings')

class Settings < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v", :default => false
  @@max_key_len = 6

  desc "set", "Update settings key => value"
  long_desc <<-LONGDESC
    `p2p - set` will set key-value of settings.

    > $ p2p - set emojis fancy
  LONGDESC
  def set(key, value)
    SETTINGS[key] = value
    Storage::write(SETTINGS, 'settings')
    puts "#{$GREEN}Successfully set '#{key}' to '#{value}' #{$DIR_S}#{$RESET}"

    puts "#{$GREY}settings - p2p #{CONFIG["version"]}#{$RESET}"
  end

  desc "list", "List settings"
  long_desc <<-LONGDESC
    `p2p - list` will list settings.

    > $ p2p - list
  LONGDESC
  def list
    puts "#{$BOLD}Settings #{$PAPER}#{$RESET}"
    SETTINGS.keys.each do |key|
      puts "#{key}:  #{' ' * (@@max_key_len - key.length)}#{SETTINGS[key]}"
    end

    puts "#{$GREY}settings - p2p #{CONFIG["version"]}#{$RESET}"
  end
  
end
