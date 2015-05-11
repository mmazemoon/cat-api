require 'socket'
require 'thread'
require 'json'

# TCP to transfer data back and forth from client and server.
# Bespoke protocol (format of the messages between c&s)
# Replace with HTTP. (Hypertext Transfer Protocol)
# HTML (Hypertext Markup Language)


Thread.abort_on_exception = true

$id = 0
$cats = []

server = TCPServer.new (3000)

# CRUD: CREATE/READ/UPDATE/DELETE servers

def handle_request(socket)
  Thread.new do
    cmd = socket.gets.chomp
    case cmd
    when "INDEX"
      socket.puts $cats.to_json
    when "SHOW"
      # GET /cats/:id
      # GET /cats/123
      # GET /dogs/456

      cat_id = Integer(socket.gets.chomp)
      cat = $cats.find{ |cat| cat[:id] == cat_id }
      socket.puts cat.to_json
    when "UPDATE"
      # PATCH /cats/123
      # PATCH /cats/456
      cat_id = Integer(socket.gets.chomp)
      cat = $cats.find{ |cat| cat[:id] == cat_id }

      new_name = socket.gets.chomp
      cat[:name] = new_name
    when "CREATE"
      # POST /cats
      # POST /dogs


      name = socket.gets.chomp
      cat_id = $id
      $id += 1

      $cats << { id: cat_id, name: name }
    when "DESTROY"
      # DELETE /cats/123
      # DELETE /dogs/456

      cat_id = Integer(socket.gets.chomp)
      $cats.reject! { |cat| cat[:id] == cat_id }
    end
    socket.close
  end
  puts "Spawned worker thread"
end

while true
  socket = server.accept
  handle_request(socket)
end
