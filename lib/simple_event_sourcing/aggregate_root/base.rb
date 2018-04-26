module SimpleEventSourcing
  module AggregateRoot

    module Base

      attr_accessor :aggregate_id
      attr_reader :events

      def initialize(_args = nil)
        @events = []
        @aggregate_id ||= SimpleEventSourcing::Id::UUIDId.generate
      end

      def have_changed?
        (@events.count > 0)
      end

      def publish_events
        published_events = @events
        clear_events
        published_events
      end

      def handle_message(message)
        handler = self.class.message_mapping[message.class]
        self.instance_exec(message, &handler) if handler
      end

      def self.included(o)
        o.extend(ClassMethods)
      end

      module ClassMethods

        def create_from_agrregate_id(id)
          aggregate = new
          aggregate.aggregate_id = id
          aggregate
        end

        def create_from_history(history)
          aggregate = self.create_from_agrregate_id history.aggregate_id
          history.each { |event| aggregate.handle_message event }
          aggregate
        end

        def on(*message_classes, &block)
          message_classes.each { |message_class| message_mapping[message_class] = block }
        end

        def message_mapping
          @message_mapping ||= {}
        end

        def handles_message?(message)
          message_mapping.keys.include? message.class
        end
      end

      private

        def apply_record_event(event_class, args = {})
          args[:aggregate_id] ||= aggregate_id
          event = event_class.new(args)
          handle_message(event)
          record_event event
        end

        def record_event(event)
          @events << event
        end

        def clear_events
          @events = []
        end


    end
  end
end
