RSpec.describe 'An event store' do
  before(:each) do
    @redis_client = SimpleEventSourcing::Events::EventStore::RedisClientMock.new
    @event_store = SimpleEventSourcing::Events::EventStore::RedisEventStore.new(@redis_client)
  end

  it 'persist an event an aggregate from its id' do
    event = DummyEvent.new(aggregate_id: '4bb20d71-3002-42ea-9387-38d6838a2cb7', a_new_value: 44, other_value: 55)

    @event_store.commit event

    expect(@redis_client.entries.count).to eq 1
  end

  it 'recover and event history from id' do
    @time_now = Time.at(1_402_358_400)

    Timecop.freeze(@time_now) do
      @event_store.commit DummyEvent.new(aggregate_id:  '4bb20d71-3002-42ea-9387-38d6838a2cb7', a_new_value: 44, other_value: 55)
      @event_store.commit DummyEvent.new(aggregate_id:  '4bb20d71-3002-42ea-9387-38d6838a2cb7', a_new_value: 22, other_value: 33)

      event_history = @event_store.get_history '4bb20d71-3002-42ea-9387-38d6838a2cb7'

      expect(event_history.aggregate_id).to eq '4bb20d71-3002-42ea-9387-38d6838a2cb7'

      expect(event_history.count).to eq 2
      expect(event_history[0].class).to eq DummyEvent
      expect(event_history[0].a_new_value).to eq 44
      expect(event_history[0].other_value).to eq 55
      expect(event_history[0].occurred_on).to eq 1_402_358_400

      expect(event_history[1].class).to eq DummyEvent
      expect(event_history[1].a_new_value).to eq 22
      expect(event_history[1].other_value).to eq 33
      expect(event_history[0].occurred_on).to eq 1_402_358_400
    end
  end
end
