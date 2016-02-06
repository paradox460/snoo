module Snoo
  module Support
    # Helper methods
    module Helpers
      protected

      def validate_arguments!(actual, required, optional)
        ensure_required_arguments(actual, required)
        ensure_valid_arguments(actual, required, optional)
      end

      private

      # Send the response data/resource through the processors for additional processing.
      #
      # Here's how processors work (if a consumer was declared with one):
      # - processors are called in the order that they are declared.
      # - the first processor in the list gets the unadulterated response data.
      # - the next processor is fed the return value of the last processor that was called before it.
      # - the return value of the last processor will be the one that is returned by the API consumer method.
      #
      def post_process(resource, processors)
        Array(processors).reduce(resource) do |data, processor|
          processor.respond_to?(:call) ? processor.call(data) :
            send(processor, data)
        end
      end

      # Converts a path string that might have params segments into a path with the param segments substituted with actual values from values.
      #
      # For example, path has param segments, and values contain keys that match those segments:
      #
      #   path   = '/foo/:id/bar/:bar_id'
      #   values = { id: 1, bar_id: 2 }
      #   request_path(path, values) # => '/foo/1/bar/2'
      #
      # path has no param segments, and values may or may not be emtpty:
      #
      #   path   = '/foo'
      #   values = { id: 1, bar_id: 2 }
      #   request_path(path, values) # => '/foo'
      #
      def request_path(path, values)
        delimiter = '/'
        path.split(delimiter)
            .reject { |item| item.length.zero? }
            .map { |item| (item =~ /^:/) ? values[item[1..-1].to_sym] : item }
            .join(delimiter)
            .prepend(delimiter)
      end

      def query_params(path, params, required, optional)
        path_params = self.class.send(:extract_params, path)
        query_keys  = (required + (optional - [:data])) - path_params
        params.select { |k, _| query_keys.include? k }
      end

      # Raise an ArgumentError if not everything listed as required is not listed in supplied.
      #
      def ensure_required_arguments(supplied, required)
        missing = supplied & required
        return if missing.sort == required.sort

        raise ArgumentError, "missing required arguments: #{missing.join(', ')}"
      end

      # Raise an ArgumentError if not everything listed in supplied appear in either the required or optional list.
      #
      def ensure_valid_arguments(supplied, required, optional)
        unrecognized = supplied - (required + optional).uniq
        return if unrecognized.empty?

        raise ArgumentError, "unrecognized arguments: #{unrecognized.join(', ')}"
      end
    end
  end
end
