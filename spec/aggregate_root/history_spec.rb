RSpec.describe SimpleEventSourcing::AggregateRoot::History do

  before(:each) do
    aggregate_id = SimpleEventSourcing::Id::UUIDId.new '4bb20d71-3002-42ea-9387-38d6838a2cb7'
    stream_events = DummyStreamEvents.new(aggregate_id)
    stream_events << DummyEvent.new(aggregate_id: aggregate_id, a_new_value: 10, other_value: 30)
    stream_events << DummyEvent.new(aggregate_id: aggregate_id, a_new_value: 20, other_value: 55)
    @aggregate = stream_events.get_aggregate
  end

  it 'is reconstruct an aggregate by a stream events' do

    expect(@aggregate.aggregate_id.to_s).to eq('4bb20d71-3002-42ea-9387-38d6838a2cb7')
    expect(@aggregate.a_field).to eq(20)
    expect(@aggregate.other_field).to eq(55)
  end

  it 'generate an aggregate whitout no stored event' do
    expect(@aggregate.have_changed?).to be false
  end
end
