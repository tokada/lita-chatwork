require "spec_helper"

describe Lita::Adapters::Chatwork, lita: true do
  let(:robot) { Lita::Robot.new(registry) }
  subject { described_class.new(robot) }
end
