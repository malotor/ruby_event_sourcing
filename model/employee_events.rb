class SalaryHasChangedEvent
  attr_reader :aggregate_id
  attr_reader :new_salary

  def initialize(aggregate_id, new_salary)
    @aggregate_id = aggregate_id
    @new_salary = new_salary
  end
end
