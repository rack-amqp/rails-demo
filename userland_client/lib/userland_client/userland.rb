module UserlandClient
  class Userland

    def initialize
    end

    def get(uri, options={})
      transport.get(uri, options)
    end

    private

    def transport
      self.class.configuration.transport
    end

    # TODO lift class out
    class Configuration
      attr_accessor :transport
    end

    module ClassMethods
      attr_writer :configuration

      def get(uri, options={})
        connection.get(uri, options)
      end

      def connection
        # Can be used for a connection pool I guess
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
