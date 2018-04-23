module SimpleEventSourcing
  module AggregateRoot
    class History < Array
      attr_reader :aggregate_id

      def initialize(aggregate_id)
        @aggregate_id = aggregate_id
      end

      def get_aggregate
        aggregate = get_aggregate_class.create_from_agrregate_id @aggregate_id
        each { |event| aggregate.apply_record_event event }
        aggregate
      end

      def get_aggregate_class
        raise StandardError('Method must be implemented')
      end
    end
  end
end
