class DummyStreamEvents < SimpleEventSourcing::AggregateRoot::History
  def get_aggregate_class
    DummyClass
  end
end

class DummyEvent < SimpleEventSourcing::Events::Event
  attr_reader :a_new_value

  def initialize(args)
    @a_new_value = args[:a_new_value]
    super(args)
  end
end

class DummyEventSubscriber < SimpleEventSourcing::Events::EventSubscriber

  def is_subscribet_to?(event)
    event.class == DummyEvent
  end

  def handle_event(event)
    puts "New value is {#{event.a_new_value}}"
  end

end

class DummyClass

  include SimpleEventSourcing::AggregateRoot::Base


  attr_accessor :a_field

  def a_field
    @a_field || :dummy_default_value
  end

  def a_method(a_value)
    apply_record_event DummyEvent, a_new_value: a_value
  end

  # def apply_dummy_event(event)
  #   @a_field = event.a_new_value
  # end

  on DummyEvent do |event|
      @a_field = event.a_new_value
  end

  def publish
    publish_events { |event| SimpleEventSourcing::Events::EventDispatcher.publish(event) }
  end
end
