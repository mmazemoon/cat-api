require 'socket'
require 'thread'

server = TCPServer.new (3000)

while true
  socket = server.accept
  socket.puts("THANKS FOR CONNECTING")
  socket.puts("What is your name, human?")
  name = socket.gets.chomp
  socket.puts("Goodbye #{name}")
  socket.close
end


# can't accept another connection because ruby is too busy
# waiting for this socket to send data
