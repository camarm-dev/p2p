require './lib/net/utils'

module Program

  def eval(content)
    lines = content.split("\n")

    lines.each do |command|
      host = P2PNet::Host
      case command
      when "DIST"
        arg = command.tr("DIST ", "")
        server = P2PServersUtilities.get(arg)
        host = P2PNet::Host.new(server['user'], server['hostname'], server['port'], server['require_password'])
      when "COPY"
        args = command.tr("COPY ", "").split(',')
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

  def run(file)
    eval(File.read(file))
  end

end
