require 'socket'

class Servarrr
  attr_accessor :client, :server

  def run
    @server = start_server

    loop do
      @client = @server.accept

      request = @client.gets
      puts request

      serve_file File.join("public", request.split(" ")[1])

      @client.close
    end
  end

  def start_server
    port   = ARGV[0] || 1337
    puts "Preparrr the cannon on port #{port}"
    TCPServer.new port
  end

  def serve_file(path)
    File.open(path, "r") do |file|
      response 200, "Content-Type: text/html", file.read
    end
  rescue Errno::ENOENT => err
    response 404, "Content-Type: text/plain", "404: File not found."
  end

  def response(status, headers, content)
    @client.puts "HTTP/1.1 #{status}"
    @client.puts headers
    @client.puts "Content-Length: #{content.length}"
    @client.puts "Connection: close"
    @client.puts
    @client.puts content

    puts "Responding with #{status}"
  end
end

Servarrr.new.run
