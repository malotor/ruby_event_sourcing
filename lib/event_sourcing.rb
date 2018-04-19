require "facets"
require 'securerandom'

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
      @@subscribers.each { |subscriber| subscriber.handle(event) if subscriber.is_subscribet_to? event }
    end

  end

  module AggregateRoot

    attr_reader :aggregate_id

    def initialize(args)
      @events = []
      @aggregate_id ||= SecureRandom.uuid
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

      def apply_event(event)
        method = "apply_" + event.class.name.snakecase
        self.send(method, event)
      end

      def apply_record_event(event)
        apply_event event
        record_event event
      end

  end

end
