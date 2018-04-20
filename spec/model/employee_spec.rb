require_relative '../../model/employee'

RSpec.describe Employee do

  let(:spy_subscriber) { spy(:spy_subscriber) }

  before(:each) do
    @employee =  Employee.new(name: "Fred Flintstone", title: "Crane Operator", salary: 30000.0)

    allow(spy_subscriber).to receive(:handle)
    allow(spy_subscriber).to receive(:is_subscribet_to?).and_return(true)
    EventSourcing::EventPublisher.add_subscriber(spy_subscriber)

  end

  after(:each) do
    EventSourcing::EventPublisher.delete_subscriber(spy_subscriber)
  end

  def validate_uuid_format(uuid)
    uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    uuid_regex =~ uuid.to_s.downcase
  end

  it "have a salary" do
    @employee.salary=35000.0
    expect(@employee.salary).to eq(35000)
  end

  it "have a UUID aggregate Id " do
    expect(validate_uuid_format(@employee.aggregate_id)).to_not be_nil
  end

  it "have one event when is created" do
    expect(@employee.events.count).to eq(1)
  end

  it "have two event if salary is changed" do
    @employee.salary=35000.0
    expect(@employee.events.count).to eq(2)
  end

  example "events are cleared when entity is persisted" do
    @employee.salary=35000.0
    @employee.save
    expect(@employee.events.count).to eq(0)
  end

  example "dispatch publish events when is persisted" do
    @employee.save
    expect(spy_subscriber).to have_received(:is_subscribet_to?)
    expect(spy_subscriber).to have_received(:handle)
  end

end
