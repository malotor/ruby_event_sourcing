RSpec.describe SimpleEventSourcing::AggregateRoot::History do

  it 'is reconstruct an aggregate by a stream events' do
    aggregate_id = SimpleEventSourcing::Id::UUIDId.new '4bb20d71-3002-42ea-9387-38d6838a2cb7'
    stream_events = DummyStreamEvents.new(aggregate_id)
    stream_events << DummyEvent.new(aggregate_id, 10)
    stream_events << DummyEvent.new(aggregate_id, 20)

    aggregate = stream_events.get_aggregate
    expect(aggregate.aggregate_id.to_s).to eq('4bb20d71-3002-42ea-9387-38d6838a2cb7')
    expect(aggregate.a_field).to eq(20)
  end
end
