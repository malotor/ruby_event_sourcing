class DummyEvent < SimpleEventSourcing::Events::Event
  attr_reader :a_new_value, :other_value

  def initialize(args)
    @a_new_value = args[:a_new_value]
    @other_value = args[:other_value]
    super(args)
  end

  def serialize
    super.merge("a_new_value" => a_new_value, "other_value" => other_value  )
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

  attr_accessor :a_field,:other_field

  def self.create(a_value, other_value)
    dummy = self.new
    dummy.apply_record_event DummyEvent, a_new_value: a_value, other_value: other_value
    dummy
  end

  def a_method(a_value, other_value)
    apply_record_event DummyEvent, a_new_value: a_value, other_value: other_value
  end

  on DummyEvent do |event|
    @a_field = event.a_new_value
    @other_field = event.other_value
  end

end
