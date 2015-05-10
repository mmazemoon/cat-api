require 'socket'
require 'thread'

server = TCPServer.new (3000)

def handle_request(socket)
  Thread.new do                     # master thread spawning worker threads.
    socket.puts("THANKS FOR CONNECTING")
    socket.puts("What is your name, human?")
    name = socket.gets.chomp
    socket.puts("Goodbye #{name}")
    socket.close
  end
  puts "Spawned worker thread"    # master thread moves on
end                               # while worker thread waits for input.


while true
  socket = server.accept
  handle_request(socket)
end


# can't accept another connection because ruby is too busy
# waiting for this socket to send data
