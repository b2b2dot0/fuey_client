require "spec_helper"

describe Fuey::Reporters::NotificationQueue do
  Given (:redis) { double "Redis" }
  Given (:q) { Fuey::Reporters::NotificationQueue.new redis }

  describe "receiving updates for new traces" do
    Given (:statuses)    { [create_status("Ping 1"), create_status("Ping 2")] }
    Given (:json_string) { {
            :name => "QA Alpha Trace",
            :status => "executed",
            :status_message => "",
            :steps => statuses.map(&:attributes)
          }.to_json }
    Given { redis.should_receive(:publish).with("fuey.trace.new", json_string) }
    When  (:result) { q.update :new, "QA Alpha Trace", statuses }
    Then  { expect( result ).to be_true, "and publish to Redis" }
  end

  describe "receiving updates for existing traces" do
    Given (:statuses)    { [create_status("Ping 1")] }
    Given (:json_string) {
      ["QA Alpha Trace", statuses.first.attributes].to_json
    }
    Given { redis.should_receive(:publish).with("fuey.trace.update", json_string) }
    When  (:result) { q.update :update, "QA Alpha Trace", statuses }
    Then  { expect( result ).to be_true, "and publish to Redis" }
  end

  def create_status(name)
    Fuey::Inspections::Support::Status.new :name => name
  end
end
