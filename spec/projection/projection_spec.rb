RSpec.describe SimpleEventSourcing::Projection do

  before(:each) do
    @projections = []
    @projections << spy('projection_1')
    @projections << spy('projection_2')
    @projections.each do |p|
      allow(p).to receive(:project_event)
    end

    SimpleEventSourcing::Projector.register(@projections)
  end

  after(:each) do
    SimpleEventSourcing::Projector.clear
  end

  it 'projects an event on all registered proyections' do
    event = Object.new
    SimpleEventSourcing::Projector.project(event)
    @projections.each do |p|
      expect(p).to have_received(:project_event).with(event)
    end
  end

end
