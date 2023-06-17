require './lib/net/utils'
require './lib/servers'
require './lib/ansi'

SERVERS = P2PServersUtilities.new()

module Program

  def self.eval(content)
    lines = content.split("\n")

    unless lines[0].start_with?("DIST")
      puts "#{$RED}First line must set the distant host with DIST keyword ! ❌#{$RESET}"
      exit
    end

    @host = P2PNet::Host
    context = '/'
    lines.each do |line|
      if line.start_with?("DIST")
        arg = line.gsub("DIST ", "")
        puts "#{$BOLD}Connecting to #{arg} #{$CON}...#{$RESET}"
        server = SERVERS.get(arg)
        special_output = ""
        if server['require_password']
          special_output = "#{$CLEAR}"
        end
        begin
          @host = P2PNet::Host.new(server['user'], server['hostname'], server['port'], server['require_password'])
          context, _ = @host.call('pwd')
          context = context.tr("\n", "")
          puts "#{$CLEAR}#{special_output}#{$BOLD}Connecting to #{arg} #{$CON_S}#{$RESET}"
        rescue
          puts "#{$CLEAR}#{special_output}#{$RED}Connecting to #{arg} #{$CON_F}#{$RESET}"
        end

      elsif line.start_with?("COPY")
        args = line.gsub("COPY ", "").split(',')
        puts "\t- Copying #{args.join(',')} #{$CLIP}..."
        begin
          @host.upload(args, context)
          puts "#{$CLEAR}#{$GREEN}\t- Copying #{args.join(',')} #{$CLIP_S}#{$RESET}"
        rescue
          puts "#{$CLEAR}#{$RED}\t- Copying #{args.join(',')} #{$CLIP_F}#{$RESET}"
        end

      elsif line.start_with?("COMMAND")
        arg = line.gsub("COMMAND ", "")
        puts "\t- Executing `#{arg}` #{$FIRE}..."
        out, success = @host.call("cd #{context} && #{arg}")
        out = out.gsub("\n", "\n\t      ")
        if success or arg.include?('mkdir') and out == ""
          puts "#{$CLEAR}#{$GREEN}\t- Executing `#{arg}` #{$FIRE_S}#{$RESET}"
        else
          puts "#{$CLEAR}#{$RED}\t- Executing `#{arg}` #{$FIRE_F}#{$RESET}"
        end
        if arg.include?('mkdir') and out == ""
          puts "#{$YELLOW}\t      -> Your `mkdir` command have probably been executed successfully but p2p is unable to receive output #{$DIR_S}#{$RESET}"
        else
          puts "\t#{$GREY}   -> #{out}#{$RESET}" if out != ''
        end

      elsif line.start_with?("CTX")
        arg = line.gsub("CTX ", "")
        puts "\t- Moving to #{arg} #{$DIR}..."
        if @host.exec(["cd #{arg}"])
          if arg.start_with?("/")
            context = arg
          elsif context.end_with?('/')
            context += arg
          else
            context += '/' + arg
          end
          puts "#{$CLEAR}#{$GREEN}\t- Moving to #{arg} #{$DIR_S}#{$RESET}"
        else
          puts "#{$CLEAR}#{$RED}\t- Moving to #{arg} #{$DIR_F}#{$RESET}"
        end

      elsif line.start_with?("#") || line == "\n" || line == ""
        next

      else
        puts "\e[33mUnknown command at line #{lines.find_index(line)}.#{$RESET}"
      end
    end
  end

  def self.run(file)
    begin
      eval(File.read(file))
    rescue
      puts "#{$RED}File not found or error occurred ❌#{$RESET}"
    end
  end

end
