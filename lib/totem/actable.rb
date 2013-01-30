module Totem
  module Actable
    def process_event(event)
      ActiveRecord::Base.connection_pool.with_connection do
        super
      end
    end
  end
end
