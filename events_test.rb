require_relative './lib/events'

class Employee

  extend Events::EventSubscriber
  include Events::AggregateRoot

  attr_reader :name, :title
  attr_reader :salary

  def initialize( name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    record_event( SalaryHasChangedEvent.new(self) )
  end
end


class SalaryHasChangedEvent

  attr_reader :employee

  def initialize(employee)
    @employee = employee
  end
end

class CongratulateEmployeeSubscriber

  def is_subscribet_to?(event)
    event.class == SalaryHasChangedEvent
  end

  def handle(event)
    puts "Cogratulations #{event.employee.name}!!!!"
  end

end

Employee.add_subscriber(CongratulateEmployeeSubscriber.new)


fred = Employee.new("Fred Flintstone", "Crane Operator", 30000.0)
fred.salary=35000.0
fred.save

barney = Employee.new("Barney Rubble", "Crane Operator", 10000.0)
barney.save
