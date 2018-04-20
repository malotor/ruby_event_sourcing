require_relative '../lib/event_sourcing'
require_relative 'employee_events'
require_relative 'employee_subscribers'
require_relative 'employee'

EventSourcing::EventPublisher.add_subscriber(CongratulateEmployeeSubscriber.new)

fred = Employee.new(name: "Fred Flintstone", title: "Crane Operator", salary: 30000.0)
fred.salary=35000.0
fred.save

barney = Employee.new(name:"Barney Rubble", title:  "Crane Operator",  salary: 10000.0)
barney.save
