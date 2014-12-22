module SimpleCQRS
  EventDescriptor = Struct.new(:id, :event_data, :version)
  class EventStore
    def initialize(publisher)
      @publisher = publisher
      @current = Hash.new{|h, k| h[k] = [] }
    end

    def save_events(aggregate_id, events, expected_version)
      event_descriptors = @current[aggregate_id]
      if expected_version != -1 && event_descriptors.last.version != expected_version
        raise "ConcurrencyError version was: #{event_descriptors.last.try(:version).inspect} - tried to update #{expected_version}"
      end

      events.each_with_index do |event, index|
        event.version = index + expected_version + 1
        event_descriptors << EventDescriptor.new(aggregate_id,event,event.version)
        @publisher.publish(event)
      end
    end

    def get_events_for_aggregate(aggregate_id)
      event_descriptors = @current.fetch(aggregate_id)
      if event_descriptors.empty?
        raise "AggregateNotFound"
      end
      event_descriptors.map(&:event_data)
    end

    def root_ids
      @current.keys
    end
  end
end
