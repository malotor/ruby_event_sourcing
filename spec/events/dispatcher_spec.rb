RSpec.describe SimpleEventSourcing::Events::EventDispatcher do

  let(:spy_subscriber) { spy(:spy_subscriber) }
  let(:spy_second_subscriber) { spy(:spy_second_subscriber) }

  before(:each) do

    SimpleEventSourcing::Events::EventDispatcher.add_subscriber(spy_subscriber)
    SimpleEventSourcing::Events::EventDispatcher.add_subscriber(spy_second_subscriber)
  end

  after(:each) do
    SimpleEventSourcing::Events::EventDispatcher.delete_subscriber(spy_subscriber)
    SimpleEventSourcing::Events::EventDispatcher.delete_subscriber(spy_second_subscriber)
  end

  it 'dispath an event to all subscribers that are subscribed to that event class' do

    allow(spy_subscriber).to receive(:handle)
    allow(spy_subscriber).to receive(:is_subscribet_to?).and_return(true)

    allow(spy_second_subscriber).to receive(:is_subscribet_to?).and_return(false)

    new_event = DummyEvent.new("a_id","a_value")

    SimpleEventSourcing::Events::EventDispatcher.publish(new_event)
    #expect(spy_subscriber).to have_received(:is_subscribet_to?)
    expect(spy_subscriber).to have_received(:handle)

    expect(spy_second_subscriber).not_to have_received(:handle)
  end


end
