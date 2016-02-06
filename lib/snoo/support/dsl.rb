require 'forwardable'

module Snoo
  module Support
    # Module for restful api dsl commands
    module Dsl
      def base_url(value = nil)
        value.nil? ? @base_url : (@base_url = value)
      end

      def base_path(value = nil)
        value.nil? ? @base_path : (@base_path = value)
      end

      protected

      # Generate whiny and stoic API consumer methods.
      #
      # Whiny methods have a bang suffix and raise errors if they fail
      # Stoic methods do not have the bang suffix and return nil if they fail
      def consume(path, as:, using: :get, params: nil, processors: nil)
        define_whiny_method as, path, using, processors, params
        define_stoic_method as
      end

      private

      # Generate an API consumer method that raises exceptions when requests return HTTP status within 400...600 range
      #
      def define_whiny_method(name, path, using, processors, params)
        required, optional = requirements(using, path, params)

        define_method :"#{name}!" do |opts = {}|
          validate_arguments! opts.keys, required, optional

          reqpath = request_path(path, opts)
          query = query_params(path, opts, required, optional)
          data = opts[:data]
          fetch(using, reqpath, data: data, query: query) do |resource, *_|
            post_process resource, processors
          end
        end
      end

      # Generate an API consumer method that returns nil when requests return HTTP statuses within 400...600 range.
      #
      def define_stoic_method(name)
        define_method name do |opts = {}|
          begin
            send(:"#{name}!", opts)
          rescue # TODO: Rescue HTTP errors
            nil
          end
        end
      end

      # Extract param segments from a path, rails routes style. Returns a list of symbols matching the names of the param segments.
      #
      # Param segments are sections of the path that begin with `:`
      def extract_params(path)
        path.split('/').reject { |i| i.length.zero? || i !~ /^:/ }.uniq.map { |i| i[1..-1].to_sym }
      end

      # Takes a request method (HTTP method, not ruby/rails method), request path, and query params, this returns the list of acceptable params for the request
      #
      # for example:
      #
      #   verb   = :get
      #   path   = '/foo/:id'
      #   params = { required: [:api_key], optional: [:offset] }
      #
      #   requirements(verb, path, params) # => [:id, :api_key, :offset]
      #
      # PUT and POST request methods imply that you can submit data and so the parameter named :data is included even if it's not declared in params.
      #
      #   verb   = :post
      #   path   = '/foo/:id'
      #   params = { required: [:api_key], optional: [:offset] }
      #
      #   requirements(verb, path, params) # => [:id, :api_key, :offset, :data]
      #
      # Note that because of this behavior, :data is effectively a 'reserved' parameter name - and so if you are declaring a consumer, keep in mind that values paired with a parameter named :data will be used as content body for consumers that utilises PUT or POST when sending a request.
      #
      def requirements(verb, path, params)
        required, optional = Hash(params).values_at(*%i(required optional)).map { |list| Array(list) }

        required += extract_params(path)
        optional << :data if %i(put post).include? verb

        [required, optional]
      end
    end
  end
end
