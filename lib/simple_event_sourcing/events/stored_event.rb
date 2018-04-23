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




    end



  end
end
