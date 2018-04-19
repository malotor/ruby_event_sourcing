class Employee

  include EventSourcing::AggregateRoot

  attr_reader :name, :title
  attr_reader :salary

  def initialize(args)

    @name = args[:name]
    @title = args[:title]
    @salary = args[:salary]
    super(args)
  end

  def salary=(new_salary)
    event =  SalaryHasChangedEvent.new(@aggregate_idm, new_salary)
    apply_record_event event
  end

  def apply_salary_has_changed_event(event)
    @salary = event.new_salary
  end

end
