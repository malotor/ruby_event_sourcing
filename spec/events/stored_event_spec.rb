RSpec.describe SimpleEventSourcing::Events::StoredEvent do

  before(:each) do

    @stored_event = SimpleEventSourcing::Events::StoredEvent.new(
      aggregate_id: SimpleEventSourcing::Id::UUIDId.generate,
      occurred_on: Time.now.getlocal("+02:00").to_i,
      event_type: :DummyEvent,
      event_data: '{"a_new_value":10}'
    )
  end

  it 'has occured on date' do
    expect(@stored_event.occurred_on).not_to be nil
  end

  it 'has a aggregate_id' do
    expect(@stored_event.aggregate_id).not_to be nil
  end

  it 'has as a type' do
    expect(@stored_event.event_type).to eq(:DummyEvent)
  end

  it 'has as a type' do
    expect(@stored_event.event_data).to eq('{"a_new_value":10}')
  end




end
