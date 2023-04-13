require 'thor'
require './lib/servers'

SERVERS = P2PServersUtilities.new()

class Servers < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"
  
  desc "add", "Add a distant host to p2p servers."
  def add
    puts "Complete the following wizard to add a p2p server:"
    SERVERS.add_wizard
  end
  
  desc "list", "List registered p2p servers"
  def list
    # ...
  end
  
  desc "remove SERVER-NAME", "Remove a p2p server."
  def remove
    # ...
  end
end
