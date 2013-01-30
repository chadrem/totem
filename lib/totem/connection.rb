module Totem
  class Connection < Tribe::EM::Connection
    include Totem::Actable

    private

    def initialize(options = {})
      options[:logger] = Totem.logger

      super
    end
  end
end
