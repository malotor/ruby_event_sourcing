require_relative '../lib/simple_event_sourcing'

class EmployeeStreamEvents < SimpleEventSourcing::AggregateRoot::History
  def get_aggregate_class
    Employee
  end
end


class NewEmployeeIsHiredEvent < SimpleEventSourcing::Events::Event
  attr_reader :name, :title,:salary

  def initialize(args)
    @name = args[:name]
    @title = args[:title]
    @salary = args[:salary]
    super(args)
  end
end

class SalaryHasChangedEvent < SimpleEventSourcing::Events::Event
  attr_reader  :new_salary

  def initialize(args)
    @new_salary = args[:new_salary]
    super(args)
  end
end

class CongratulateEmployeeSubscriber < SimpleEventSourcing::Events::EventSubscriber

  def is_subscribet_to?(event)
    event.class == SalaryHasChangedEvent
  end

  def handle(event)
    puts "Cogratulations for your new salary => #{event.new_salary}!!!!"
  end

end


class Employee

  include SimpleEventSourcing::AggregateRoot::Base

  attr_reader :name, :title, :salary

  def initialize(args = nil )
    super
    unless args.nil?
      apply_record_event  NewEmployeeIsHiredEvent , name: args[:name],  title: args[:title], salary: args[:salary] 
    end
  end

  def salary=(new_salary)
    apply_record_event SalaryHasChangedEvent , new_salary: new_salary
  end

  on NewEmployeeIsHiredEvent do |event|
    @name = event.name
    @title = event.title
    @salary = event.salary
  end

  on SalaryHasChangedEvent do |event|
    @salary = event.new_salary
  end

  def save
    # Persist the entity
    publish_events { |event| SimpleEventSourcing::Events::EventDispatcher.publish(event) }
  end

end
