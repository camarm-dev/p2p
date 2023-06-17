require 'net/ssh'
require 'net/scp'
require 'net/ping'

module P2PNet
    class Host
        
        def initialize(user, hostname, port, password=false)
            @user = user
            @host = hostname
            @port = port
            @required_password = password
            @conn = nil
            if password
                @password = IO::console.getpass "#{user}@#{hostname} password: "
                p "#{$CLEAR}"
            end
        end

        def test
            if Net::Ping::External.new(@host).ping
                if @required_password
                    Net::SSH.start(@host, @user, port: @port, password: @password) do |ssh| 
                        ssh.exec!("whoami")
                    end
                else
                    Net::SSH.start(@host, @user, port: @port) do |ssh| 
                        ssh.exec!("whoami")
                    end
                end
                return true
            end
        end

        def exec(commands=[])
            if @required_password
                ssh = Net::SSH.start(@host, @user, port: @port, password: @password)
            else
                ssh = Net::SSH.start(@host, @user, port: @port)
            end
            commands.each do |command|
                ssh.exec(command) do |_, success|
                    return false unless success
                end
            end
            return true
        end

        def call(command)
            if @required_password
                ssh = Net::SSH.start(@host, @user, port: @port, password: @password)
            else
                ssh = Net::SSH.start(@host, @user, port: @port)
            end
            out, success = '', false
            ssh.exec!(command) do |_, stream, data|
                out = data
                if stream == :stderr
                    success = false
                else
                    success = true
                end
            end
            return out, success
        end

        def upload(files=[], context='~')
            if @required_password
                ssh = Net::SCP.start(@host, @user, port: @port, password: @password)
            else
                ssh = Net::SCP.start(@host, @user, port: @port)
            end
            upload_success = true
            files.each do |file|
                filename = file.split('/')[-1]
                ssh.upload!(file, "#{context}/#{filename}") do |_, success|
                    unless success
                        upload_success = false
                    end
                end
            end
            abort "Failed to copy one or all files..." unless upload_success
        end
    end
end
