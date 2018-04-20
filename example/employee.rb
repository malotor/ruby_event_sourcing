require_relative '../lib/simple_event_sourcing'

class EmployeeStreamEvents < SimpleEventSourcing::StreamEvents
  def get_aggregate_class
    Employee
  end
end


class NewEmployeeIsHiredEvent < SimpleEventSourcing::Event
  attr_reader :name, :title,:salary

  def initialize(aggregate_id, name, title, salary)
    @aggregate_id = aggregate_id
    @name = name
    @title = title
    @salary = salary
    super()
  end
end

class SalaryHasChangedEvent < SimpleEventSourcing::Event
  attr_reader :aggregate_id, :new_salary

  def initialize(aggregate_id, new_salary)
    @aggregate_id = aggregate_id
    @new_salary = new_salary
    super()
  end
end


class Employee

  include SimpleEventSourcing::AggregateRoot

  attr_reader :name, :title, :salary

  def initialize(args = nil )
    super
    unless args.nil?
      apply_record_event  NewEmployeeIsHiredEvent.new(@aggregate_id, args[:name], args[:title], args[:salary] )
    end
  end

  def salary=(new_salary)
    apply_record_event SalaryHasChangedEvent.new(@aggregate_id, new_salary)
  end

  def apply_new_employee_is_hired_event(event)
    @name = event.name
    @title = event.title
    @salary = event.salary
  end

  def apply_salary_has_changed_event(event)
    @salary = event.new_salary
  end

  def save
    # Persist the entity
    publish_events { |event| SimpleEventSourcing::EventPublisher.publish(event) }
  end

end
