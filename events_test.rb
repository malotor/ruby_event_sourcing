require_relative 'lib/event_sourcing'
require_relative 'model/employee_events'
require_relative 'model/employee_subscribers'
require_relative 'model/employee'

EventSourcing::EventPublisher.add_subscriber(CongratulateEmployeeSubscriber.new)

fred = Employee.new("Fred Flintstone", "Crane Operator", 30000.0)
fred.salary=35000.0
fred.save

barney = Employee.new("Barney Rubble", "Crane Operator", 10000.0)
barney.save
