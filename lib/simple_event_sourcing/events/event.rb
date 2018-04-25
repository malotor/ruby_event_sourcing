module SimpleEventSourcing
  module Events

    class Event
      attr_reader :aggregate_id, :occured_on

      def initialize(args)
        @aggregate_id = args[:aggregate_id]
        @occured_on ||= Time.new
      end
    end
  end
end
