RSpec.describe SimpleEventSourcing::Events::EventSubscriber do

  let(:dummy_event) { DummyEvent.new("an_id","a_value") }
  let(:no_dummy_event)  do
    Object.const_set("DinamicEvent", Class.new { })
    DinamicEvent.new
  end

  before(:each) do
    @subscriber = DummyEventSubscriber.new
  end

  it 'is subscribed to especific class of event' do
    expect(@subscriber.is_subscribet_to?(dummy_event)).to be true
    expect(@subscriber.is_subscribet_to?(no_dummy_event)).to be false
  end

  it 'is handles to especific class of event' do
    expect { @subscriber.handle(no_dummy_event) }.to raise_error SimpleEventSourcing::Events::EventIsNotAllowedToBeHandled
  end

end
