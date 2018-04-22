# EventSourcing

The fundamental idea of Event Sourcing is that of ensuring every change to the state of an application is captured in an event object, and that these event objects are themselves stored in the sequence they were applied for the same lifetime as the application state itself.

Martin Fowler , https://martinfowler.com/eaaDev/EventSourcing.html

This gem provides a simple way for add events sourcing related behaviour to your models class.

Base classes

- AggregateRoot
- Event
- EventStream
- EventPublisher

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_event_sourcing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_event_sourcing

## Usage

Here an example of use:

```ruby
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
```

Firts you mus add behaviour including the AggregateRoot module

```ruby
  include SimpleEventSourcing::AggregateRoot
```

After that all domain event must be applied and recorded

```ruby
apply_record_event SalaryHasChangedEvent.new(@aggregate_id, new_salary)
```

You must create your own events and a event stream

```ruby
class EmployeeStreamEvents < SimpleEventSourcing::StreamEvents
  def get_aggregate_class
    Employee
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
```

Once you persist the entity you must publish all recorded events.

```ruby
  def save
    # Persist the entity
    publish_events { |event| SimpleEventSourcing::EventPublisher.publish(event) }
  end
```

Happy coding!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/event_sourcing. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EventSourcing project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/event_sourcing/blob/master/CODE_OF_CONDUCT.md).
