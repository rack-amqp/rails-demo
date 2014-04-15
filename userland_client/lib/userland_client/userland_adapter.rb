module UserlandClient
  class UserlandAdapter

    def initialize
    end

    def get(uri, options={})
      transport.get(target(uri), options)
    end

    def post(uri, options={})
      transport.post(target(uri), options)
    end

    def target(uri)
      c = self.class.configuration
      "#{c.protocol}://#{c.queue}#{uri}"
    end

    private

    def transport
      self.class.configuration.transport
    end

    # TODO lift class out
    class Configuration
      attr_accessor :transport, :protocol, :queue
      def hostname=(val)
        self.queue = val
      end
      def hostname
        self.queue
      end
    end

    module ClassMethods
      attr_writer :configuration

      def get(uri, options={})
        connection.get(uri, options)
      end

      def post(uri, options={})
        connection.post(uri, options)
      end

      def connection
        # Should be constructed with current config to allow for overriding, oh well
        new
      end

      def configuration
        @configuration ||= Configuration.new
      end

      def configure(&block)
        yield configuration
      end
    end

    extend ClassMethods
  end
end
