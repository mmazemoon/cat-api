require 'socket'
require 'thread'
require 'json'

# TCP to transfer data back and forth from client and server.
# Bespoke protocol (format of the messages between c&s)
# Replace with HTTP. (Hypertext Transfer Protocol)
# HTML (Hypertext Markup Language)

Thread.abort_on_exception = true

$id = 2
$cats = [
  {id: 1, name: "Wonton"},
  {id: 2, name: "Curie"}
  ]

server = TCPServer.new (3000)
# CRUD: CREATE/READ/UPDATE/DELETE servers

def handle_request(socket)

  Thread.new do
    # method path protocol_version
    line1 = socket.gets.chomp

    re = /^([^ ]+) ([^ ]+) HTTP\/1.1$/
    match_data = re.match(line1)
    verb = match_data[1]
    path = match_data[2]

    cat_regex = /\/cats\/(\d+)/

    if [verb, path] == ["GET", "/cats"] # INDEX
      # GET /cats
      socket.puts $cats.to_json
    elsif verb == "GET" && cat_regex =~ path # SHOW
      # GET /cats/123
      match_data2 = cat_regex.match(path)
      cat_id = Integer(match_data2[1])

      cat = $cats.find{ |cat| cat[:id] == cat_id }
      socket.puts cat.to_json
    elsif verb == "DELETE" && cat_regex =~ path
      # DELETE /cats/123
      match_data2 = cat_regex.match(path)
      cat_id = Integer(match_data2[1])
      $cats.reject! { |cat| cat[:id] == cat_id }

      socket.puts true.to_json
    end

      # when "UPDATE"
      #   # PATCH /cats/123
      #   # PATCH /cats/456
      #   cat_id = Integer(socket.gets.chomp)
      #   cat = $cats.find{ |cat| cat[:id] == cat_id }
      #
      #   new_name = socket.gets.chomp
      #   cat[:name] = new_name
      # when "CREATE"
      #   # POST /cats
      #   # POST /dogs
      #   name = socket.gets.chomp
      #   cat_id = $id
      #   $id += 1
      #   $cats << { id: cat_id, name: name }

      socket.close
    end
      puts "Spawned worker thread"
end

while true
  socket = server.accept
  handle_request(socket)
end
