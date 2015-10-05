require_relative 'simone'

nina = Simone::Base.new

nina.get "/hello" do
  "Nina Simone says hello!"
end

nina.get "/" do
  [200, {}, request.body]
end

nina.post "/" do
  [200, {}, request.body]
end

p nina.routes

# Rack handlers take a Rack app and actually run them.
Rack::Handler::WEBrick.run nina, Port: 9292
