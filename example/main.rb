
unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)+'/../lib'))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)+'/../lib'))
end

require 'simple_event_sourcing'
require_relative './employee'

SimpleEventSourcing::Events::EventDispatcher.add_subscriber(CongratulateEmployeeSubscriber.new)

fred = Employee.new(name: "Fred Flintstone", title: "Crane Operator", salary: 30000.0)
fred.salary=35000.0
fred.save

barney = Employee.new(name:"Barney Rubble", title:  "Crane Operator",  salary: 10000.0)
barney.save
