module EventSourcing

  module EventPublisher

    @@subscribers=[]

    def self.add_subscriber(subscriber)
      @@subscribers << subscriber
    end

    def self.delete_subscriber(subscripber)
      @@subscribers.delete(subscriber)
    end

    def self.get_subscribers
      @@subscribers
    end

    def self.publish(event)
      @@subscribers.each do |subscriber|
        subscriber.handle(event) if subscriber.is_subscribet_to? event
      end
    end

  end

  module AggregateRoot

    def initialize
      @events = []
      super()
    end

    def save
      # Persist the entity
      publish_events
      clear_events
    end

    def publish_events()
      @events.each do |event|
        EventSourcing::EventPublisher.publish(event)
      end
    end

    private
      def record_event(event)
        @events << event
      end

      def clear_events
        @events = []
      end

  end

end
