RSpec.describe SimpleEventSourcing::AggregateRoot::Base do


  let(:spy_subscriber) { spy(:spy_subscriber) }

  before(:each) do
    @dummy_class = DummyClass.new

    allow(spy_subscriber).to receive(:handle)
    allow(spy_subscriber).to receive(:is_subscribet_to?).and_return(true)
    SimpleEventSourcing::Events::EventDispatcher.add_subscriber(spy_subscriber)
  end

  after(:each) do
    SimpleEventSourcing::Events::EventDispatcher.delete_subscriber(spy_subscriber)
  end


  it 'have a UUID aggregate Id' do
    expect(uuid_valid?(@dummy_class.aggregate_id)).to_not be_nil
  end

  it 'new instances has no changes' do
    expect(@dummy_class.have_changed?).to be false
    expect(@dummy_class.events.count).to eq(0)
    expect(@dummy_class.a_field).to eq(:dummy_default_value)
  end

  it 'applies and store events' do
    @dummy_class.a_method(10,30)


    expect(@dummy_class.a_field).to eq(10)
    expect(@dummy_class.other_field).to eq(30)

    expect(@dummy_class.have_changed?).to be true
    expect(@dummy_class.events.count).to eq(1)
  end

  it 'applies and store events several times' do
    @dummy_class.a_method(10,30)
    @dummy_class.a_method(15,35)

    expect(@dummy_class.a_field).to eq(15)
    expect(@dummy_class.other_field).to eq(35)

    expect(@dummy_class.have_changed?).to be true
    expect(@dummy_class.events.count).to eq(2)
  end

  it 'publish its stored events' do
    @dummy_class.a_method(10,30)
    @dummy_class.publish
    expect(spy_subscriber).to have_received(:is_subscribet_to?)
    expect(spy_subscriber).to have_received(:handle)
  end

  it 'clears events after publish its' do
    @dummy_class.a_method(10,30)
    @dummy_class.publish
    expect(@dummy_class.events.count).to eq(0)
  end

  it 'is reconstructed by a events history' do

    aggregate_id = SimpleEventSourcing::Id::UUIDId.new '4bb20d71-3002-42ea-9387-38d6838a2cb7'
    stream_events = SimpleEventSourcing::AggregateRoot::History.new(aggregate_id)
    stream_events << DummyEvent.new(aggregate_id: aggregate_id, a_new_value: 10, other_value: 30)
    stream_events << DummyEvent.new(aggregate_id: aggregate_id, a_new_value: 20, other_value: 55)
    @aggregate = DummyClass.create_from_history stream_events

    expect(@aggregate.aggregate_id.to_s).to eq('4bb20d71-3002-42ea-9387-38d6838a2cb7')
    expect(@aggregate.a_field).to eq(20)
    expect(@aggregate.other_field).to eq(55)
    expect(@aggregate.have_changed?).to be false
  end


end
