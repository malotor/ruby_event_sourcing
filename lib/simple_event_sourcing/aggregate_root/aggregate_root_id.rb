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
  end

  class UUIDAggregateRootId < AggregateRootId
    def initialize
      super(SecureRandom.uuid)
    end
  end
end
