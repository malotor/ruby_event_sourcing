require_relative '../../model/employee'

RSpec.describe Employee do
  let(:spy_subscriber) { spy(:spy_subscriber) }

  before(:each) do
    @employee = Employee.new(name: 'Fred Flintstone', title: 'Crane Operator', salary: 30_000.0)

    allow(spy_subscriber).to receive(:handle)
    allow(spy_subscriber).to receive(:is_subscribet_to?).and_return(true)
    EventSourcing::EventPublisher.add_subscriber(spy_subscriber)
  end

  after(:each) do
    EventSourcing::EventPublisher.delete_subscriber(spy_subscriber)
  end

  it 'have a salary' do
    @employee.salary = 35_000.0
    expect(@employee.salary).to eq(35_000)
    expect(@employee.name).to eq('Fred Flintstone')
    expect(@employee.title).to eq('Crane Operator')
  end

  it 'is reconstructed by a stream events' do
    aggregate_id = 'an_aggregate_id'
    stream_events = EmployeeStreamEvents.new(aggregate_id)
    stream_events << NewEmployeeIsHiredEvent.new(aggregate_id, 'Fred Flintstone', 'Crane Operator', 30_000.0)
    stream_events << SalaryHasChangedEvent.new(aggregate_id, 45_000.0)

    employee = stream_events.get_aggregate
    expect(employee.aggregate_id).to eq(aggregate_id)
    expect(employee.name).to eq('Fred Flintstone')
    expect(employee.title).to eq('Crane Operator')
    expect(employee.salary).to eq(45_000.0)
  end
end
