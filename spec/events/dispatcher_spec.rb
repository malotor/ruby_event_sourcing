RSpec.describe SimpleEventSourcing::Events::EventDispatcher do

  let(:spy_subscriber) { @subscribers[0] }
  let(:spy_second_subscriber) { @subscribers[1] }

  before(:each) do
    @subscribers = []
    @subscribers << spy(:spy_subscriber)
    @subscribers << spy(:spy_subscriber)

    @subscribers.each { |s| SimpleEventSourcing::Events::EventDispatcher.add_subscriber(s) }

  end

  after(:each) do
    @subscribers.each { |s| SimpleEventSourcing::Events::EventDispatcher.delete_subscriber(s) }
  end

  it 'dispath an event to all subscribers that are subscribed to that event class' do

    allow(spy_subscriber).to receive(:handle)
    allow(spy_subscriber).to receive(:is_subscribet_to?).and_return(true)

    allow(spy_second_subscriber).to receive(:is_subscribet_to?).and_return(false)

    new_event = DummyEvent.new(aggregate_id: "a_id", a_new_value: "a_value")

    SimpleEventSourcing::Events::EventDispatcher.publish(new_event)
    #expect(spy_subscriber).to have_received(:is_subscribet_to?)
    expect(spy_subscriber).to have_received(:handle)

    expect(spy_second_subscriber).not_to have_received(:handle)
  end


end
