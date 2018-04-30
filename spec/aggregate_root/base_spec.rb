RSpec.describe SimpleEventSourcing::AggregateRoot::Base do
  before(:each) do
   @dummy_class = DummyClass.create(1, 2)
 end

  it 'have a UUID aggregate Id' do
    expect(uuid_valid?(@dummy_class.aggregate_id)).to_not be_nil
  end

  it 'new instances has no recorded events' do
    expect(@dummy_class.have_changed?).to be true
    expect(@dummy_class.a_field).to eq(1)
    expect(@dummy_class.other_field).to eq(2)
  end

  it 'applies and store events' do

    @dummy_class.a_method(10,30)

    expect(@dummy_class.a_field).to eq(10)
    expect(@dummy_class.other_field).to eq(30)

    expect(@dummy_class.have_changed?).to be true
  end

  it 'applies and store events several times' do
    @dummy_class.a_method(10,30)
    @dummy_class.a_method(15,35)

    expect(@dummy_class.a_field).to eq(15)
    expect(@dummy_class.other_field).to eq(35)

    expect(@dummy_class.have_changed?).to be true

  end

  it 'publish its stored events' do
    @dummy_class.a_method(10,30)
    published_events = @dummy_class.publish
    expect(published_events.count).to be > 0
  end

  it 'clears events once they have been published' do
    @dummy_class.a_method(10,30)
    published_events = @dummy_class.publish
    expect(@dummy_class.have_changed?).to be false
  end

  it 'is reconstructed by a events history' do

    aggregate_id = SimpleEventSourcing::Id::UUIDId.new '4bb20d71-3002-42ea-9387-38d6838a2cb7'
    history = SimpleEventSourcing::AggregateRoot::History.new(aggregate_id)
    history << DummyEvent.new(aggregate_id: aggregate_id, a_new_value: 10, other_value: 30)
    history << DummyEvent.new(aggregate_id: aggregate_id, a_new_value: 20, other_value: 55)
    @aggregate = DummyClass.create_from_history history

    expect(@aggregate.aggregate_id.to_s).to eq('4bb20d71-3002-42ea-9387-38d6838a2cb7')
    expect(@aggregate.a_field).to eq(20)
    expect(@aggregate.other_field).to eq(55)
    expect(@aggregate.have_changed?).to be false
  end


end
