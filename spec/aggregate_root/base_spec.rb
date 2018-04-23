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


  it 'have a UUID aggregate Id ' do
    expect(uuid_valid?(@dummy_class.aggregate_id)).to_not be_nil
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


end
