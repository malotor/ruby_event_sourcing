class Employee

  include EventSourcing::AggregateRoot

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
