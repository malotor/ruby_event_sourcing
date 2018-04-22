RSpec.describe "Events" do

  require_relative 'dummy'


  before(:each) do
    @dummy_evet = DummyEvent.new("an_aggregate_id","a new value")
  end


  it 'has a occured on date' do
    expect(@dummy_evet.occured_on).not_to be nil
  end


end
