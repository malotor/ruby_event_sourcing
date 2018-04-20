require "facets"
require 'securerandom'

module EventSourcing

  class Event
    attr_reader :occurred_on

    def initialize
      @occurred_on ||= Time.new
    end

  end

  class StreamEvents < Array

    attr_reader :aggregate_id

    def initialize(aggregate_id)
      @aggregate_id = aggregate_id
    end

    def get_aggregate
      aggregate = get_aggregate_class.create_from_agrregate_id  @aggregate_id
      self.each { |event| aggregate.apply_record_event event }
      return aggregate
    end

    def get_aggregate_class
      raise StandarError("Method must be implemented") 
    end

  end

  module EventPublisher

    @@subscribers=[]

    def self.add_subscriber(subscriber)
      @@subscribers << subscriber
    end

    def self.delete_subscriber(subscriber)
      @@subscribers.delete(subscriber)
    end

    def self.get_subscribers
      @@subscribers
    end

    def self.publish(event)
      @@subscribers.each { |subscriber| subscriber.handle(event) if subscriber.is_subscribet_to? event }
    end

  end

  module AggregateRoot

    def self.included(o)
      o.extend(ClassMethods)
    end

    attr_accessor :aggregate_id
    attr_reader :events

    def initialize(args = nil)
      @events = []
      @aggregate_id ||= SecureRandom.uuid
    end


    def have_changed?
      ( @events.count > 0 )
    end

    def publish_events(&block)
      @events.each do |event|
        block.call(event)
      end
      clear_events
    end

    def apply_record_event(event)
      apply_event event
      record_event event
    end



    private
      def record_event(event)
        @events << event
      end

      def clear_events
        @events = []
      end

      def apply_event(event)
        method = "apply_" + event.class.name.snakecase
        self.send(method, event)
      end

    module ClassMethods
      def create_from_agrregate_id(id)
        aggregate = new
        aggregate.aggregate_id = id
        return aggregate
      end
    end


  end




end
