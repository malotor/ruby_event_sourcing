module SimpleEventSourcing
  module Events

    class Event
      attr_reader :occured_on

      def initialize
        @occured_on ||= Time.new
      end
    end
  end
end
