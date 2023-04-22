require './lib/net/utils'
require './lib/servers'

SERVERS = P2PServersUtilities.new()

module Program

  def self.eval(content)
    lines = content.split("\n")

    unless lines[0].start_with?("DIST")
      puts "\e[31mFirst line must set the distant host with DIST keyword ! ❌\e[0m"
      exit
    end

    @host = P2PNet::Host
    lines.each do |line|
      if line.start_with?("DIST")
        arg = line.gsub("DIST ", "")
        puts "\e[1mConnecting to #{arg}...\e[0m"
        server = SERVERS.get(arg)
        @host = P2PNet::Host.new(server['user'], server['hostname'], server['port'], server['require_password'])
      elsif line.start_with?("COPY")
        args = line.gsub("COPY ", "").split(',')
        current_dir = @host.call('pwd').tr("\n", "")
        puts "\t- Copying #{args.join(',')}"
        @host.upload(args, current_dir)
      elsif line.start_with?("COMMAND")
        arg = line.gsub("COMMAND ", "")
        puts "\t- Executing `#{arg}`"
        out = @host.call(arg)
        puts "\t\e[2m   -> #{out}\e[0m"
      elsif line.start_with?("CTX")
        arg = line.gsub("CTX ", "")
        puts "\t- Moving to #{arg}"
        @host.exec(["cd #{arg}"])
      elsif line.start_with?("#") || line == "\n" || line == ""
        next
      else
        puts "\e[33mUnknown command at line #{lines.find_index(line)}.\e[0m"
      end
    end
  end

  def self.run(file)
    begin
      eval(File.read(file))
    rescue
      puts "\e[31mFile not found or error occurred ❌\e[0m"
    end
  end

end
