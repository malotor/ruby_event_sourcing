module SimpleEventSourcing
  module Events

    class Event
      attr_reader :aggregate_id, :occurred_on

      def initialize(args)
        @aggregate_id = args[:aggregate_id]
        @occurred_on ||= Time.new
      end
    end
  end
end
