RSpec.describe SimpleEventSourcing::Events::Event do

  before(:each) do

    @time_now = Time.at(1402358400)

    Timecop.freeze(@time_now) do
      @dummy_event = DummyEvent.new(
        aggregate_id: SimpleEventSourcing::Id::UUIDId.new('4bb20d71-3002-42ea-9387-38d6838a2cb7'),
        a_new_value: 'a new value'
      )
    end


  end

  it 'has a occurred on date' do
    expect(@dummy_event.occurred_on).to eq 1402358400
  end

  it 'has a aggregate_id on date' do
    expect(@dummy_event.aggregate_id.to_s).to eq('4bb20d71-3002-42ea-9387-38d6838a2cb7')
  end

  it 'rails if aggregrate_id is not provided' do
    expect { SimpleEventSourcing::Events::Event.new }.to raise_error ArgumentError
  end

  it 'is serializable' do
    event_hash = @dummy_event.serialize
    expect(event_hash["aggregate_id"]).to eq '4bb20d71-3002-42ea-9387-38d6838a2cb7'
    expect(event_hash["occurred_on"]).to eq 1402358400
    expect(event_hash["a_new_value"]).to eq 'a new value'
    expect(event_hash["other_value"]).to be nil
  end


end
