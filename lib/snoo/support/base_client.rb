module Snoo
  module Support
    # Basic underlying client. Pretty much a wrapper around HTTP.rb
    class BaseClient
      extend Dsl
      include Helpers

      def initialize(); end

      def fetch(method, path, data: nil, query: nil, &_block)
        response = request(method, path, data: data, query: query)
        status = response.status
        resource = response.body
        block_given? ? yield(resource, status, response) : resource
      end

      def request(method, path, data: nil, query: nil)
        path = self.class.base_path + path
        args = [method, path]
        args << data.to_json unless data.nil?
        # HTTP request logic goes here
      end
    end
  end
end
