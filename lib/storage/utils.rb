require 'json'

module Storage
    FOLDER = "#{Dir.home}/.p2p"

    def self.write(data, name)
        File.write("#{FOLDER}/#{name}.json", JSON.dump(data))
    end

    def self.read(name)
        return JSON.parse(File.read("#{FOLDER}/#{name}.json"))
    end
end
