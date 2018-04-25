module SimpleEventSourcing
  module Events
    class EventSubscriber

      def is_subscribet_to?(event)
        raise StandardError "Method not implemented"
      end

      def check(event)
        raise EventIsNotAllowedToBeHandled unless is_subscribet_to? event
      end

      def handle_event(event)
        raise StandardError "Method not implemented"
      end

      def handle(event)
        check event
        handle_event event
      end

    end

    class EventIsNotAllowedToBeHandled < StandardError; end

  end
end
