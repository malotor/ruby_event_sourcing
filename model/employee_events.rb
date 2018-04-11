class SalaryHasChangedEvent

  attr_reader :employee

  def initialize(employee)
    @employee = employee
  end
end
