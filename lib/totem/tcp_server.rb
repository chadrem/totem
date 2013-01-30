module Totem
  class TcpServer < Tribe::EM::TcpServer
    include Totem::Actable

    private

    def initialize(ip, port, conn_class, options = {})
      options[:logger] = Totem.logger

      super
    end
  end
end
