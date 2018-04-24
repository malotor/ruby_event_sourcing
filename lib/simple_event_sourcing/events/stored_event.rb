module SimpleEventSourcing
  module Events

    class StoredEvent
      attr_reader :aggregate_id, :occurred_on, :event_type, :event_data

      def initialize(args)
        @aggregate_id = args[:aggregate_id]
        @occurred_on = args[:occurred_on]
        @event_type = args[:event_type]
        @event_data = args[:event_data]
      end

      def to_json(*a)
        {"aggregate_id" => aggregate_id.to_s, "occurred_on" => occurred_on.to_s, "event_type" => event_type.to_s, "event_data" => event_data.to_s }.to_json(*a)
      end

    end

  end
end
