class DummyStreamEvents < SimpleEventSourcing::StreamEvents
  def get_aggregate_class
    DummyClass
  end
end

class DummyEvent < SimpleEventSourcing::Event
  attr_reader :aggregate_id, :a_new_value

  def initialize(aggregate_id, a_new_value)
    @aggregate_id = aggregate_id
    @a_new_value = a_new_value
    super()
  end
end

class DummyClass
  include SimpleEventSourcing::AggregateRoot

  attr_accessor :a_field

  def a_field
    @a_field || :dummy_default_value
  end

  def a_method(a_value)
    apply_record_event DummyEvent.new(aggregate_id, a_value)
  end

  def apply_dummy_event(event)
    @a_field = event.a_new_value
  end

  def publish
    publish_events { |event| SimpleEventSourcing::EventPublisher.publish(event) }
  end
end
