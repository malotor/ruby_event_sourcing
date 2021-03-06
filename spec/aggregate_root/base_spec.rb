RSpec.describe SimpleEventSourcing::AggregateRoot::Base do
  before(:each) do
   @dummy_class = DummyClass.create(1, 2)
 end

  it 'have a aggregate Id' do
    expect(uuid_valid?(@dummy_class.aggregate_id)).to_not be_nil
  end

  it 'could not be created from constructor' do
    expect { DummyClass.new }.to raise_error NoMethodError
  end

  it 'new instances should have firts inital event' do
    expect(@dummy_class.have_changed?).to be true
    expect(@dummy_class.count_events).to be 1
    expect(@dummy_class.a_field).to eq(1)
    expect(@dummy_class.other_field).to eq(2)
  end

  it 'applies and store events when object state is changed' do

    @dummy_class.a_method(10,30)

    expect(@dummy_class.have_changed?).to be true
    expect(@dummy_class.count_events).to be 2
    expect(@dummy_class.a_field).to eq(10)
    expect(@dummy_class.other_field).to eq(30)

  end

  it 'applies and store events several times' do
    @dummy_class.a_method(10,30)
    @dummy_class.a_method(15,35)

    expect(@dummy_class.have_changed?).to be true
    expect(@dummy_class.count_events).to be 3
    expect(@dummy_class.a_field).to eq(15)
    expect(@dummy_class.other_field).to eq(35)

  end

  it 'publish its stored events' do
    @dummy_class.a_method(10,30)
    published_events = @dummy_class.publish
    expect(published_events.count).to be 2
    published_events.each { |e| expect(e).to be_an_instance_of DummyEvent }
  end

  it 'clears stored events once they have been published' do
    @dummy_class.a_method(10,30)
    published_events = @dummy_class.publish
    expect(@dummy_class.have_changed?).to be false
  end

  it 'each event should have the aggregate_id' do
    @dummy_class.a_method(10,30)
    published_events = @dummy_class.publish
    published_events.each { |e| expect(e.aggregate_id).to be @dummy_class.aggregate_id.value }
  end

  it 'supports several types of id' do
    other_aggregate = OtherDummyClass.create(10)
    published_events = other_aggregate.publish
    published_events.each { |e| expect(e.aggregate_id).to be 1 }
    expect(other_aggregate.id).to be 1
  end

  it 'is reconstructed by a events history' do

    aggregate_id = '4bb20d71-3002-42ea-9387-38d6838a2cb7'
    history = SimpleEventSourcing::AggregateRoot::History.new(aggregate_id)
    history << DummyEvent.new(aggregate_id: aggregate_id, a_new_value: 10, other_value: 30)
    history << DummyEvent.new(aggregate_id: aggregate_id, a_new_value: 20, other_value: 55)
    @aggregate = DummyClass.create_from_history history

    expect(@aggregate.aggregate_id.to_s).to eq('4bb20d71-3002-42ea-9387-38d6838a2cb7')
    expect(@aggregate.a_field).to eq(20)
    expect(@aggregate.other_field).to eq(55)
    expect(@aggregate.have_changed?).to be false

    @aggregate.a_method(30,60)

    expect(@aggregate.a_field).to eq(30)
    expect(@aggregate.other_field).to eq(60)
    expect(@aggregate.have_changed?).to be true

  end


end
