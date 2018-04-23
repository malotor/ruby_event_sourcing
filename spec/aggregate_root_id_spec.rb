RSpec.describe 'Aggregate Root Id' do
  it 'is a valid UUID' do
    aggregate_id = SimpleEventSourcing::Id::UUIDId.generate
    expect(uuid_valid?(aggregate_id.to_s)).not_to be nil
  end

  it 'is created from a  UUID' do
    aggregate_id = SimpleEventSourcing::Id::UUIDId.new 'cd2d7408-e230-49fa-a22b-51a004ecbec0'
    expect(uuid_valid?(aggregate_id.to_s)).not_to be nil
    expect(aggregate_id.to_s).to eq('cd2d7408-e230-49fa-a22b-51a004ecbec0')
  end

  it 'is fails if  string is no valid  UUID' do
    expect { SimpleEventSourcing::Id::UUIDId.new('foo') }.to raise_error(SimpleEventSourcing::Id::UUIDValidationError)
  end

  it 'is equal to other UUID if both have same value' do
    aggregate_id = SimpleEventSourcing::Id::UUIDId.new 'cd2d7408-e230-49fa-a22b-51a004ecbec0'
    other_aggregate_id = SimpleEventSourcing::Id::UUIDId.new 'cd2d7408-e230-49fa-a22b-51a004ecbec0'
    expect(other_aggregate_id == aggregate_id).to be true
  end

  it 'is difrente to other UUID if have different value' do
    aggregate_id = SimpleEventSourcing::Id::UUIDId.new 'cd2d7408-e230-49fa-a22b-51a004ecbec0'
    other_aggregate_id = SimpleEventSourcing::Id::UUIDId.new '4bb20d71-3002-42ea-9387-38d6838a2cb7'
    expect(other_aggregate_id == aggregate_id).to be false
  end
end
