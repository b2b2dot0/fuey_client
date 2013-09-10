require 'spec_helper'

describe Fuey::TraceRepository do
  after(:each) { Fuey::Config::Fuey.reload_configuration }

  describe "retrieving all configured traces" do
    context "when configured for no traces" do
      Given { Fuey::Config::Fuey.test_with(no_traces) }
      When  (:result) { Fuey::TraceRepository.new.all }
      Then  { expect( result ).to be_empty }
    end

    context "when configured with one trace" do
      Given { Fuey::Config::Fuey.test_with(two_pings) }
      When  (:result) { Fuey::TraceRepository.new.all }
      Then  { expect( result ).to have(1).items }
      And   { expect( result.first ).to be_a(Fuey::Trace) }
      And   { expect( result.first ).to have(2).steps }
      And   { expect( result.first.steps[0] ).to  ping("Google").at("8.8.8.8") }
      And   { expect( result.first.steps[1] ).to  ping("Self").at("172.0.0.1") }
    end
  end

  RSpec::Matchers.define :ping do |name|
    match do |actual|
      (actual.name == name) && (actual.host == @host)
    end

    chain :at do |host|
      @host = host
    end

    failure_message_for_should do
      %(should have pinged #{name} at #{@host}, but was #{actual.name} and #{actual.host})
    end

    failure_message_for_should_not do
      %(should not have pinged #{actual.host})
    end

    description do
      %(should ping #{name} at #{@host})
    end
  end

  def two_pings
    {
      "traces" => {
        "two_pings" =>
        [
         {
           "Ping" => {
             "name" => "Google",
             "host" => "8.8.8.8"
           }
         },
         {
           "Ping" => {
             "name" => "Self",
             "host" => "172.0.0.1"
           }
         }
        ]
      }
    }
  end

  def no_traces
    {
      "traces" => {}
    }
  end
end
