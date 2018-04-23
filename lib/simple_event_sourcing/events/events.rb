module SimpleEventSourcing
  module Events

    class Event
      attr_reader :occured_on

      def initialize
        @occured_on ||= Time.new
      end
    end

    class EventSubscriber

      def is_subscribet_to?(event)
        raise StandardError "Method not implemented"
      end

      def check(event)
        raise EventIsNotAllowedToBeHandled unless is_subscribet_to? event
      end

      def handle_event(event)
        raise StandardError "Method not implemented"
      end

      def handle(event)
        check event
        handle_event event
      end

    end

    class EventIsNotAllowedToBeHandled < StandardError; end

    module EventDispatcher
      @@subscribers = []

      def self.add_subscriber(subscriber)
        @@subscribers << subscriber
      end

      def self.delete_subscriber(subscriber)
        @@subscribers.delete(subscriber)
      end

      def self.get_subscribers
        @@subscribers
      end

      def self.publish(event)
        @@subscribers.each { |subscriber| subscriber.handle(event) if subscriber.is_subscribet_to? event }
      end
    end

  end
end
