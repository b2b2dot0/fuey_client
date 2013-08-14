require 'spec_helper'

describe Fuey::Trace do
  after(:each) { Fuey::Config.reload_configuration }

  describe "retrieving all configured traces" do
    context "when configured for no traces" do
      Given { Fuey::Config.test_with(no_traces) }
      When  (:result) { Fuey::Trace.all }
      Then  { expect( result ).to be_empty }
    end

    context "when configured with one trace" do
      Given { Fuey::Config.test_with(two_pings) }
      When  (:result) { Fuey::Trace.all }
      Then  { expect( result ).to have(1).items }
      And   { expect( result.first ).to be_a(Fuey::Trace) }
      And   { expect( result.first ).to have(2).steps }
      And   { expect( result.first.steps[0] ).to  ping("Google").at("8.8.8.8") }
      And   { expect( result.first.steps[1] ).to  ping("Self").at("172.0.0.1") }
    end
  end

  describe "running a trace" do
    context "when the first step fails" do
      Given (:step1) { double(Fuey::Inspections::Ping, :name => "step1", :execute => false) }
      Given (:step2) { double(Fuey::Inspections::Ping) }
      Given { step2.should_not_receive(:execute) }
      When  (:result) { Fuey::Trace.new(:name => "trace1", :steps => [step1, step2]).run }
      Then  { expect( result ).to eql(%[trace1 failed on step1. 2 steps, 1 executed, 1 failed.]) }
    end

    context "when all steps pass" do
      Given (:step1) { double(Fuey::Inspections::Ping, :name => "step1", :execute => true) }
      Given (:step2) { double(Fuey::Inspections::Ping, :name => "step2", :execute => true) }
      When  (:result) { Fuey::Trace.new(:name => "trace1", :steps => [step1, step2]).run }
      Then  { expect( result ).to eql(%[trace1 passed. 2 steps, 2 executed, 0 failed.]) }
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
