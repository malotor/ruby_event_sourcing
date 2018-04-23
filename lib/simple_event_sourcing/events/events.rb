module SimpleEventSourcing
  module Events

    class Event
      attr_reader :occured_on

      def initialize
        @occured_on ||= Time.new
      end
    end

    class StreamEvents < Array
      attr_reader :aggregate_id

      def initialize(aggregate_id)
        @aggregate_id = aggregate_id
      end

      def get_aggregate
        aggregate = get_aggregate_class.create_from_agrregate_id @aggregate_id
        each { |event| aggregate.apply_record_event event }
        aggregate
      end

      def get_aggregate_class
        raise StandardError('Method must be implemented')
      end
    end

    class EventSubscriber

      def is_subscribet_to?(event)
        raise StandardError "Method not implemented"
      end

      def handle(event)
        raise StandardError "Method not implemented"
      end
    end


    module EventPublisher
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
