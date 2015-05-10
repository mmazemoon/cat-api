require 'socket'
require 'thread'
require 'json'

$cats = []

server = TCPServer.new (3000)

def handle_request(socket)
  Thread.new do
    cmd = socket.gets.chomp
    case cmd
    when "INDEX"
      socket.puts $cats.to_json
    when "CREATE"
      name = socket.gets.chomp
      $cats << { name: name }
    end

    socket.close
  end
  puts "Spawned worker thread"
end


while true
  socket = server.accept
  handle_request(socket)
end
