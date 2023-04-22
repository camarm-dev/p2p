require './lib/net/utils'

module Program

  def self.eval(content)
    lines = content.split("\n")
    context = ''

    lines.each do |command|
      host = P2PNet::Host
      case command
      when "DIST"
        arg = command.tr("DIST ", "")
        server = P2PServersUtilities.get(arg)
        host = P2PNet::Host.new(server['user'], server['hostname'], server['port'], server['require_password'])
      when "COPY"
        args = command.tr("COPY ", "").split(',')
        current_dir = host.exec('pwd')
        host.upload(args, current_dir)
      #   TODO: perform copy
      when "COMMAND"
        arg = command.tr("COMMAND ", "")
        host.exec([arg])
      when "CTX"
        arg = command.tr("CTX ", "")
        host.exec(["cd #{arg}"])
      else
        if :verbose
          puts "Unknown command at line #{lines.find_index(command)}."
        end
      end
    end
  end

  def self.run(file)
    eval(File.read(file))
  end

end
