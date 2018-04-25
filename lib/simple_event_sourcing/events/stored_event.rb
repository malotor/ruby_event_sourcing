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
        {"aggregate_id" => @aggregate_id.to_s, "occurred_on" => @occurred_on.to_i, "event_type" => @event_type.to_s, "event_data" => @event_data }.to_json(*a)
      end

      def self.create_from_json(json)

        stored_event_hash = JSON.parse(json)

        self.new(
          aggregate_id: stored_event_hash['aggregate_id'],
          occurred_on: stored_event_hash['occurred_on'],
          event_type: stored_event_hash['event_type'],
          event_data: stored_event_hash['event_data']
        )

      end

    end

  end
end
