module SimpleEventSourcing
  module Projection

    def self.included(o)
      o.extend(ClassMethods)
    end

    def project_event(event)
      handler = self.class.event_mapping[event.class]
      self.instance_exec(event, &handler) if handler
    end

    module ClassMethods
      def event_mapping
        @event_mapping ||= {}
      end

      def project(*message_classes, &block)
        message_classes.each { |message_class| event_mapping[message_class] = block }
      end
    end

  end

  class Projector

    attr_accessor :projections

    @@projections = []

    def self.register(args)
      @@projections.concat args if args.kind_of?(Array)
      @@projections << args unless args.kind_of?(Array)
    end

    def self.clear
      @@projections.clear
    end

    def self.project(event)
      @@projections.each { |projection| projection.project_event(event) }
    end

  end
end
