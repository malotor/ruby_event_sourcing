require 'securerandom'

module SimpleEventSourcing

  module Id

    class BaseId
      def initialize(value)
        @value = value
      end

      def id
        @value
      end

      def to_s
        @value
      end

      def ==(other_id)
        self.class == other_id.class && @value == other_id.id
      end

      alias eql? ==

    end

    class UUIDId < BaseId
      def initialize(value)
        raise UUIDValidationError unless valid? value
        super(value)
      end

      def self.generate
        new SecureRandom.uuid
      end

      private

        def valid?(uuid)
          uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
          return true if uuid_regex =~ uuid.to_s.downcase
          return false
        end
    end

    class UUIDValidationError < StandardError
      def initialize(msg="Value is not a valid UUID")
        super
      end
    end

  end
end
