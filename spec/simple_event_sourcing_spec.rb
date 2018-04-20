RSpec.describe SimpleEventSourcing do
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

  let(:spy_subscriber) { spy(:spy_subscriber) }

  before(:each) do
    @dummy_class = DummyClass.new

    allow(spy_subscriber).to receive(:handle)
    allow(spy_subscriber).to receive(:is_subscribet_to?).and_return(true)
    SimpleEventSourcing::EventPublisher.add_subscriber(spy_subscriber)
  end

  after(:each) do
    SimpleEventSourcing::EventPublisher.delete_subscriber(spy_subscriber)
  end

  def validate_uuid_format(uuid)
    uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    uuid_regex =~ uuid.to_s.downcase
  end

  it 'has a version number' do
    expect(SimpleEventSourcing::VERSION).not_to be nil
  end

  it 'have a UUID aggregate Id ' do
    expect(validate_uuid_format(@dummy_class.aggregate_id)).to_not be_nil
  end

  it 'new instances has no changes' do
    expect(@dummy_class.have_changed?).to be false
    expect(@dummy_class.events.count).to eq(0)
    expect(@dummy_class.a_field).to eq(:dummy_default_value)
  end

  it 'applies and store events' do
    @dummy_class.a_method(10)

    expect(@dummy_class.a_field).to eq(10)
    expect(@dummy_class.have_changed?).to be true
    expect(@dummy_class.events.count).to eq(1)
  end

  it 'publish its stored events' do
    @dummy_class.a_method(10)
    @dummy_class.publish
    expect(spy_subscriber).to have_received(:is_subscribet_to?)
    expect(spy_subscriber).to have_received(:handle)
  end

  it 'clears events after publish its' do
    @dummy_class.a_method(10)
    @dummy_class.publish
    expect(@dummy_class.events.count).to eq(0)
  end

  it 'is reconstructed by a stream events' do
    aggregate_id = 'an_aggregate_id'
    stream_events = DummyStreamEvents.new(aggregate_id)
    stream_events << DummyEvent.new(aggregate_id, 10)
    stream_events << DummyEvent.new(aggregate_id, 20)

    aggregate = stream_events.get_aggregate
    expect(aggregate.aggregate_id).to eq(aggregate_id)
    expect(aggregate.a_field).to eq(20)
  end
end
