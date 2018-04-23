RSpec.describe 'Events' do
  require_relative 'dummy'

  before(:each) do
    @dummy_evet = DummyEvent.new(SimpleEventSourcing::UUIDAggregateRootId.new('4bb20d71-3002-42ea-9387-38d6838a2cb7'), 'a new value')
  end

  it 'has a occured on date' do
    expect(@dummy_evet.occured_on).not_to be nil
  end

  it 'has a aggregate_id on date' do
    expect(@dummy_evet.aggregate_id.to_s).to eq('4bb20d71-3002-42ea-9387-38d6838a2cb7')
  end
end
