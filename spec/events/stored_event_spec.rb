RSpec.describe SimpleEventSourcing::Events::StoredEvent do

  before(:each) do

    @stored_event = SimpleEventSourcing::Events::StoredEvent.new(
      aggregate_id: 'an_id',
      occurred_on: 1402394400,
      event_type: 'DummyEvent',
      event_data: '{"a_new_value":10}'
    )
  end

  it 'has occured on date' do
    expect(@stored_event.occurred_on).to eq(1402394400)
  end

  it 'has a aggregate_id' do
    expect(@stored_event.aggregate_id).to eq('an_id')
  end

  it 'has as a type' do
    expect(@stored_event.event_type).to eq('DummyEvent')
  end

  it 'has as a data' do
    expect(@stored_event.event_data).to eq('{"a_new_value":10}')
  end

  it 'is seriablizable' do
    expect(@stored_event.serialize).to eq('{"aggregate_id":"an_id","occurred_on":1402394400,"event_type":"Dummy","event_data":{"a_new_value":10}}')
  end


end
