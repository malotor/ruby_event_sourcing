# EventSourcing


DISCLAIMER

This gem is under development. DO NOT USE IN PRODUCTION ENVIRONMENT!!!!

>The fundamental idea of Event Sourcing is that of ensuring every change to the state of an application is captured in an event object, and that these event objects are themselves stored in the sequence they were applied for the same lifetime as the application state itself.
>
>Martin Fowler , [https://martinfowler.com/eaaDev/EventSourcing.html](https://martinfowler.com/eaaDev/EventSourcing.html)

This gem provides a simple way of adding event sourcing behaviour to your models class.

You could find this base classes:

- AggregateRoot
- Id
- History
- Event
- EventDispatcher
- EventSubscriber
- StoredEvent
- RedisEventStore

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

Firts of all, you must add "event sourcing" behaviour to your model including the AggregateRoot Base Module

```ruby
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

  def id
    aggregate_id.to_s
  end

  on NewEmployeeIsHiredEvent do |event|
    @name = event.name
    @title = event.title
    @salary = event.salary
  end

  on SalaryHasChangedEvent do |event|
    @salary = event.new_salary
  end

end

```

You must create your own domain events

```ruby

class SalaryHasChangedEvent  < SimpleEventSourcing::Events::Event
  attr_reader  :new_salary

  def initialize(args)
    @new_salary = args[:new_salary]
    super(args)
  end

  def serialize
    super.merge("new_salary" => new_salary)
  end

end

```

After that, we must provide a handle in the out model for all domain event. SimpleEventSourcing provides a DSL to handle the applied events. You must provide a handler for each event

```ruby
  on SalaryHasChangedEvent do |event|
    @salary = event.new_salary
  end
```

Now you could apply and record events.

```ruby
apply_record_event SalaryHasChangedEvent , new_salary: new_salary
```

Once you persist the entity you must store and publish all recorded events.
```ruby
class EmployeeRepository
  def initialize(event_store)
    @event_store = event_store
  end

  def save(employee)
    employee.events.each do |event|
      @event_store.commit event
      SimpleEventSourcing::Events::EventDispatcher.publish(event)
    end
  end

  def findById(id)
    history = @event_store.get_history id
    return Employee.create_from_history history
  end
end

```

This gem provides a Redis Event Store or if you want, you could create your own usign "EventStoreBase" interface.

You could see this example running in  https://github.com/malotor/simple_event_sourcing_example

Happy coding!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/event_sourcing. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EventSourcing project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/event_sourcing/blob/master/CODE_OF_CONDUCT.md).
