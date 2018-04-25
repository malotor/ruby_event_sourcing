module SimpleEventSourcing
  module Events
    class EventStore

      def commit(event)
        raise StandardError "This methid must be implemented"
      end

      def get_history(aggregate_id)
        raise StandardError "This methid must be implemented"
      end
    end

  end
end
