require 'rack'

module Simone
  class Base
    attr_reader :routes, :request

    def initialize
      @routes = {}
    end

    def get(path, &handler)
      route('GET', path, &handler)
    end

    def post(path, &handler)
      route('POST', path, &handler)
    end

    def put(path, &handler)
      route('PUT', path, &handler)
    end

    def patch(path, &handler)
      route('PATCH', path, &handler)
    end

    def delete(path, &handler)
      route('DELETE', path, &handler)
    end

    def params
      @request.params
    end

    def call(env)
      # Rack::Request lets us replace direct env access like env["REQUEST_METHOD"]s
      @request = Rack::Request.new(env)
      verb = @request.request_method
      path = @request.path_info

      # now we get and call the block (if it exists)
      handler = @routes.fetch(verb, {}).fetch(path,nil)
      if handler
        # by using instance_eval the block has access to Simone::Base instance’s methods/variables
        result = instance_eval(&handler)
        result = [200, {}, [result]] if result.class == String
      else
        [404, {}, ['Oops, this route does not exist']]
      end
    end

    private

    def route(type, path, &handler)
      @routes[type] ||= {}
      @routes[type][path] = handler
    end
  end
end


