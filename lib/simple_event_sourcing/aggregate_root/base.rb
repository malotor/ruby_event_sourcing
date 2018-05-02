module SimpleEventSourcing
  module AggregateRoot

    module Base

      attr_accessor :aggregate_id

      def initialize(_args = nil)
        @events = []
      end

      def have_changed?
        (@events.count > 0)
      end

      def count_events
        @events.count
      end

      def publish
        published_events = @events
        clear_events
        published_events
      end

      def apply_event(event)
        handler = self.class.event_mapping[event.class]
        self.instance_exec(event, &handler) if handler
      end

      def apply_record_event(event_class, args = {})
        args[:aggregate_id] ||= aggregate_id.value
        event = event_class.new(args)
        apply_event event
        record_event event
      end

      def id
        @aggregate_id.value
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
          history.each { |event| aggregate.apply_event event }
          aggregate
        end

        def on(*message_classes, &block)
          message_classes.each { |message_class| event_mapping[message_class] = block }
        end

        def event_mapping
          @event_mapping ||= {}
        end

        def handles_event?(event)
          event_mapping.keys.include? event.class
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
end
