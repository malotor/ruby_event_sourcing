require 'securerandom'

module SimpleEventSourcing
  class AggregateRootId
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
      self.class == other_id.class &&
        value == other_id.value
    end
    alias eql? ==
  end

  class UUIDAggregateRootId < AggregateRootId
    def initialize(value)
      throw AggregateRootIdError unless valid? value
      super(value)
    end

    def self.generate
      new SecureRandom.uuid
    end

    private

    def valid?(uuid)
      uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
      uuid_regex =~ uuid.to_s.downcase
    end
  end

  class AggregateRootIdError < StandardError; end
end
