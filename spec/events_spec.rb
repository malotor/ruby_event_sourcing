RSpec.describe 'Events' do
  require_relative 'dummy'

  before(:each) do
    @dummy_evet = DummyEvent.new('an_aggregate_id', 'a new value')
  end

  it 'has a occured on date' do
    expect(@dummy_evet.occured_on).not_to be nil
  end

  it 'has a aggregate_id on date' do
    expect(@dummy_evet.aggregate_id).to eq('an_aggregate_id')
  end
end
