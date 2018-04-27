require 'json'

module SimpleEventSourcing
  module Events
    module EventStore
      class RedisEventStore < SimpleEventSourcing::Events::EventStore::EventStoreBase

        def initialize(client)
          @redis = client
        end

        def commit(event)

          stored_event = SimpleEventSourcing::Events::StoredEvent.new(
            aggregate_id: event.aggregate_id.to_s,
            occurred_on: Time.now.getlocal("+02:00").to_i,
            event_type: event.class.name,
            event_data: event.to_json
          )

          @redis.rpush(event.aggregate_id.to_s, stored_event.to_json )

        end

        def get_history(aggregate_id)
          stored_events_json = @redis.lrange( aggregate_id, 0, -1 )
          history = SimpleEventSourcing::AggregateRoot::History.new(aggregate_id)
          stored_events_json.each do |stored_event_json|
            stored_event =  SimpleEventSourcing::Events::StoredEvent.create_from_json stored_event_json
            event = Object.const_get(stored_event.event_type)
            args = JSON.parse(stored_event.event_data)
            args.keys.each do |key|
              args[(key.to_sym rescue key) || key] = args.delete(key)
            end
            recovered_event = event.new(args)
            history << recovered_event
          end
          history
        end
      end
    end
  end
end
