RSpec.describe SimpleEventSourcing::AggregateRoot::History do

  before(:each) do
    @aggregate_id = '4bb20d71-3002-42ea-9387-38d6838a2cb7'
    @stream_events = SimpleEventSourcing::AggregateRoot::History.new(@aggregate_id)
  end

  it 'is has an aggregate id' do
    expect(@stream_events.aggregate_id).to eq('4bb20d71-3002-42ea-9387-38d6838a2cb7')
    expect(@stream_events.count).to eq(0)
  end

  it 'stores event' do
    @stream_events << DummyEvent.new(aggregate_id: @aggregate_id, a_new_value: 10, other_value: 30)
    @stream_events << DummyEvent.new(aggregate_id: @aggregate_id, a_new_value: 20, other_value: 55)
    expect(@stream_events.count).to eq(2)
  end

end
