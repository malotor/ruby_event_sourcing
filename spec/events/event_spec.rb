RSpec.describe SimpleEventSourcing::Events::Event do

  before(:each) do
    @dummy_evet = DummyEvent.new(
      aggregate_id: SimpleEventSourcing::Id::UUIDId.new('4bb20d71-3002-42ea-9387-38d6838a2cb7'),
      a_new_value: 'a new value'
    )
  end

  it 'has a occured on date' do
    expect(@dummy_evet.occured_on).not_to be nil
  end

  it 'has a aggregate_id on date' do
    expect(@dummy_evet.aggregate_id.to_s).to eq('4bb20d71-3002-42ea-9387-38d6838a2cb7')
  end

  it 'rails if aggregrate_id is not provided' do
    expect { SimpleEventSourcing::Events::Event.new }.to raise_error ArgumentError
  end

end
