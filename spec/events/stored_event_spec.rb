RSpec.describe SimpleEventSourcing::Events::StoredEvent do

  before(:each) do

    @stored_event = SimpleEventSourcing::Events::StoredEvent.new(
      aggregate_id: 'an_id',
      occurred_on: 1402394400,
      event_type: 'DummyEvent',
      event_data: "{\"a_new_value\":10}"
    )

    @json = '{"aggregate_id":"an_id","occurred_on":1402394400,"event_type":"DummyEvent","event_data":"{\"a_new_value\":10}"}'
  end

  it 'is seriablizable' do
    expect(@stored_event.to_json).to eq(@json)
  end


  it 'is created form a json' do

    stored_event = SimpleEventSourcing::Events::StoredEvent.create_from_json @json

    expect(stored_event.aggregate_id).to eq "an_id"
    expect(stored_event.occurred_on).to eq 1402394400
    expect(stored_event.event_type).to eq "DummyEvent"
    expect(stored_event.event_data).to eq "{\"a_new_value\":10}"

  end

end
