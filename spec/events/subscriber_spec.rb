RSpec.describe SimpleEventSourcing::Events::EventSubscriber do

  let(:dummy_event) { @event }
  let(:no_dummy_event) { @other_event }

  Object.const_set("DinamicEvent", Class.new { })

  before(:each) do
    @subscriber = DummyEventSubscriber.new
    @event =  DummyEvent.new(aggregate_id: "an_id",a_new_value: "a_value")
    @other_event =  DinamicEvent.new
  end

  it 'is subscribed to especific class of event' do
    expect(@subscriber.is_subscribet_to?(dummy_event)).to be true
    expect(@subscriber.is_subscribet_to?(no_dummy_event)).to be false
  end

  it 'is handles to especific class of event' do
    expect { @subscriber.handle(no_dummy_event) }.to raise_error SimpleEventSourcing::Events::EventIsNotAllowedToBeHandled
  end

end
