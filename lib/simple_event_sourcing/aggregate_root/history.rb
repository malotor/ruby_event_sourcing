module SimpleEventSourcing
  module AggregateRoot
    class History < Array
      attr_reader :aggregate_id

      def initialize(aggregate_id)
        @aggregate_id = aggregate_id
      end

    end
  end
end
