require 'json'

module SimpleEventSourcing
  module Events

    class Event
      attr_reader :aggregate_id, :occurred_on

      def initialize(args)
        @aggregate_id = args[:aggregate_id]
        @occurred_on ||= Time.now.getlocal("+02:00").to_i
      end

      def serialize
        {"aggregate_id" => aggregate_id, "occurred_on" => occurred_on }
      end

      def to_json(*a)
        serialize.to_json(*a)
      end
    end
  end
end
