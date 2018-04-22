require 'securerandom'
require 'facets'

require_relative 'self_applier'

module SimpleEventSourcing
  module AggregateRoot

    attr_accessor :aggregate_id
    attr_reader :events

    def initialize(_args = nil)
      @events = []
      @aggregate_id ||= SecureRandom.uuid
    end

    def have_changed?
      (@events.count > 0)
    end

    def publish_events
      @events.each do |event|
        yield(event)
      end
      clear_events
    end

    def apply_record_event(event)
      handle_message(event)
      record_event event
    end

    def self.included(o)
      o.extend(ClassMethods)
    end

    module ClassMethods
      def create_from_agrregate_id(id)
        aggregate = new
        aggregate.aggregate_id = id
        aggregate
      end
    end

    private

      def record_event(event)
        @events << event
      end

      def clear_events
        @events = []
      end

      def apply_event(event)
        handle_message(event)
        #method = 'apply_' + event.class.name.snakecase
        #send(method, event)
      end

  end
end
