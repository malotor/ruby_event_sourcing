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

  private_class_method :new

  attr_accessor :a_field,:other_field

  def self.create(a_value, other_value)
    dummy = new
    dummy.aggregate_id = SimpleEventSourcing::Id::UUIDId.generate
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

class OtherDummyEvent < SimpleEventSourcing::Events::Event
  attr_reader :a_new_value

  def initialize(args)
    @a_new_value = args[:a_new_value]
    super(args)
  end

  def serialize
    super.merge("a_new_value" => a_new_value )
  end

end

class OtherDummyClass

  include SimpleEventSourcing::AggregateRoot::Base

  private_class_method :new

  attr_accessor :a_field

  def self.create(a_value)
    dummy = new
    dummy.aggregate_id = SimpleEventSourcing::Id::BaseId.new 1
    dummy.apply_record_event OtherDummyEvent, a_new_value: a_value
    dummy
  end

  def a_method(a_value)
    apply_record_event OtherDummyEvent, a_new_value: a_value
  end

  on OtherDummyEvent do |event|
    @a_field = event.a_new_value
  end

end
