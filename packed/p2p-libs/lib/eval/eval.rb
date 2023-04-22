require '/usr/lib/p2p/lib/net/utils'
require '/usr/lib/p2p/lib/servers'

SERVERS = P2PServersUtilities.new()

module Program

  def self.eval(content)
    lines = content.split("\n")

    unless lines[0].start_with?("DIST")
      puts "First line must set the distant host with DIST keyword ! ❌"
      exit
    end

    @host = P2PNet::Host
    lines.each do |line|
      if line.start_with?("DIST")
        arg = line.gsub("DIST ", "")
        puts "Connecting to #{arg}"
        server = SERVERS.get(arg)
        @host = P2PNet::Host.new(server['user'], server['hostname'], server['port'], server['require_password'])
      elsif line.start_with?("COPY")
        args = line.gsub("COPY ", "").split(',')
        current_dir = @host.call('pwd').tr("\n", "")
        puts "Copying #{args.join(',')}"
        @host.upload(args, current_dir)
      elsif line.start_with?("COMMAND")
        arg = line.gsub("COMMAND ", "")
        puts "Executing $~ #{arg}"
        out = @host.call(arg)
        puts "\t-> #{out}"
      elsif line.start_with?("CTX")
        arg = line.gsub("CTX ", "")
        puts "Moving to #{arg}"
        @host.exec(["cd #{arg}"])
      else
        puts "Unknown command at line #{lines.find_index(line)}."
      end
    end
  end

  def self.run(file)
    eval(File.read(file))
  end

end
