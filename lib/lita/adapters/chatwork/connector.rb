# coding: utf-8
require 'chatwork'

module Lita
  module Adapters
    class Chatwork < Adapter
      class Connector
        attr_reader :robot

        def initialize(robot, api_key: nil, interval: nil, with_reply: nil, debug: nil)
          @robot      = robot
          @api_key    = api_key
          @interval   = interval
          @with_reply = with_reply
          @debug      = debug
        end

        def connect
          raise "api_key is required." unless @api_key
          ChatWork.api_key = @api_key

          define_robot

          loop do
            wait
            result = ChatWork::Room.get

            if result.is_a?(ChatWork::APIError)
              @logger.error "ChatWork::Room.get result: #{result} (#{result.message})"
              break
            end

            rooms = result.select{|r| r["sticky"] == false && r["unread_num"] > 0 } || []
            rooms.each do |r|
              wait
              result = ChatWork::Message.get(room_id: r["room_id"])
              next if result.is_a?(ChatWork::APIError)
              result.each do |m|
                next if m["account"]["account_id"] == @me["account_id"]
                user = Lita::User.find_by_id(m["account"]["account_id"])
                unless user
                  user = Lita::User.create(m["account"]["account_id"],
                                           m["account"].merge("mention_name" =>
                                           "[To:#{m["account"]["account_id"]}] #{m["account"]["name"]}さん"))
                end
                source_id = [r["room_id"], m["message_id"], m["send_time"], m["update-time"]].join("-")
                case r["type"]
                  when "my"
                    next
                  when "direct"
                    source = Lita::Source.new(user: user, room: source_id, private_message: true)
                  else # "group"
                    source = Lita::Source.new(user: user, room: source_id)
                end
                message = Lita::Message.new(robot, m["body"], source)
                message.command! if source.private_message?
                message.command! if message.body =~ /#{@robot.mention_name}/
                message.command! if message.body =~ /\[(?:rp|返信) aid=#{@me["account_id"]} to=\d+-\d+\]/
                robot.receive(message)
              end
            end
          end
        end

        def message(target, strings)
          text = strings.join("\n")
          room_id, message_id, send_time, update_time = target.room.split("-")
          if target.user
            reply_text = "[rp aid=#{target.user.id} to=#{room_id}-#{message_id}] #{target.user.name}さん\n#{text}"
            ChatWork::Message.create(room_id: room_id, body: reply_text)
          else
            ChatWork::Message.create(room_id: room_id, body: text)
          end
        end

        def set_topic(target, topic)
          #TODO: support PUT /rooms/#{target.room}?name=#{topic}
        end

        def part(room_id)
          #TODO: support DELETE /rooms/#{room_id}?action_type=leave
        end

        private

        def define_robot
          begin
            @me = ChatWork::Me.get
            @robot.name = @me["name"]
            @robot.mention_name = "[To:#{@me["account_id"]}]"
          end
        end

        def wait
          sleep @interval
        end
      end
    end
  end
end
