require 'facets'

RSpec.describe "Aggregate Root Id" do

  it 'is a valid UUID' do
    aggregate_id = SimpleEventSourcing::UUIDAggregateRootId.new
    expect(uuid_valid? aggregate_id.to_s ).not_to be nil
  end

  it 'is created from a  UUID' do
    aggregate_id = SimpleEventSourcing::UUIDAggregateRootId.new(value: 'cd2d7408-e230-49fa-a22b-51a004ecbec0')
    expect(uuid_valid? aggregate_id.to_s ).not_to be nil
    expect(aggregate_id.to_s ).to eq('cd2d7408-e230-49fa-a22b-51a004ecbec0')
  end

end
