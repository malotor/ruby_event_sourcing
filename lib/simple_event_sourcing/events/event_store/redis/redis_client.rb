require 'redis'

module SimpleEventSourcing
  module Events
    module EventStore
    
      module RedisClient
        class << self
          attr_writer :configuration
        end

        def self.configuration
          @configuration ||= Configuration.new
        end

        def self.reset
          @configuration = Configuration.new
        end

        def self.configure
          yield(configuration)
        end

        class Configuration
          attr_accessor :host,:port,:mock

          def initialize
            @host ='localhost'
            @port = 6379
            @mock = false
          end
        end


        def self.get_client
          if @configuration.mock
            return RedisClientMock.new
          else
            return Redis.new(
              host: @configuration.host,
              port: @configuration.port
            )
          end
        end

      end

      class RedisClientMock
        attr_reader :entries

        def initialize
          @entries = Hash.new()
        end
        def rpush(key, value)
          @entries[key] ||= []
          @entries[key] << value
        end
        def lrange(key,inf,max)
          @entries[key] ||= []
          return @entries[key]
        end
      end

    end
  end
end
