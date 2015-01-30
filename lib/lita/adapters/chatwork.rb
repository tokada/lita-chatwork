require 'lita'
require 'lita/adapters/chatwork/connector'

module Lita
  module Adapters
    class Chatwork < Adapter
      config :api_key, type: String, required: true
      config :interval, type: Fixnum, default: 5
      config :with_reply, default: true # whether to include [rp] tag in reply message
      config :debug, default: false

      def initialize(robot)
        super
        @connector = Connector.new(robot,
          api_key:    config.api_key,
          interval:   config.interval,
          with_reply: config.with_reply,
          debug:      config.debug,
        )
      end
      attr_reader :connector

      def join(room_id)
        # NOT supported
      end

      def part(room_id)
        # NOT YET supported
        connector.part(room_id)
      end

      def set_topic(target, topic)
        # NOT YET supported
        connector.set_topic(target, topic)
      end

      def send_messages(target, strings)
        connector.message(target, strings)
      end

      def run
        connector.connect
        robot.trigger(:connected)
        sleep
      rescue Interrupt
        shut_down
      end

      def shut_down
        robot.trigger(:disconnected)
      end
    end

    Lita.register_adapter(:chatwork, Chatwork)
  end
end
