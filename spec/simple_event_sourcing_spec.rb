RSpec.describe SimpleEventSourcing do

  require_relative 'dummy'

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
    aggregate_id = SimpleEventSourcing::Id::UUIDId.new '4bb20d71-3002-42ea-9387-38d6838a2cb7'
    stream_events = DummyStreamEvents.new(aggregate_id)
    stream_events << DummyEvent.new(aggregate_id, 10)
    stream_events << DummyEvent.new(aggregate_id, 20)

    aggregate = stream_events.get_aggregate
    expect(aggregate.aggregate_id.to_s).to eq('4bb20d71-3002-42ea-9387-38d6838a2cb7')
    expect(aggregate.a_field).to eq(20)
  end
end
