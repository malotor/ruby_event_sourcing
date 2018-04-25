module SimpleEventSourcing
  module Events
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
