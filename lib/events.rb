
module Events

  module EventSubscriber

    @@subscribers=[]

    def add_subscriber(subscriber)
      @@subscribers << subscriber
    end
    def delete_subscriber(subscripber)
      @@subscribers.delete(subscriber)
    end

    def get_subscribers
      @@subscribers
    end
  end

  module AggregateRoot

    extend Events::EventSubscriber

    def initialize
      clear_events
      super()
    end


    def save
      # Persist the entity
      @events.each do |event|
        publish(event)
      end
    end

    def publish(event)

      raise StandarError('Class can not publish events') if !self.class.respond_to? :get_subscribers

      self.class.get_subscribers.each do |subscriber|
        subscriber.handle(event) if subscriber.is_subscribet_to? event
      end
      clear_events
    end

    private
      def record_event(event)
        @events << event
      end

      def clear_events
        @events = []
      end

  end

end
