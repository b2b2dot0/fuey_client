require "spec_helper"

describe Fuey::Client do

  describe "#initialize" do
    context "passing a configuration path" do
      Given { Configurethis.should_receive(:root_path=).with('path/to/dir') }
      When (:result) { Fuey::Client.new 'path/to/dir' }
      Then { expect( result ).to be_a(Fuey::Client) }
    end
  end

  describe "#run" do
    after(:each) { Fuey::Config.reload_configuration }

    context "when nothing is configured" do
      Given { Fuey::Log.should_receive(:write).with("Nothing configured.") }
      Given { Fuey::Config.test_with(no_inspections) }
      When  (:result) { Fuey::Client.new.run }
      Then  { expect( result ).to eql(0) }
    end

    context "when one ping is configured" do
      Given { Fuey::Config.test_with(one_ping) }
      Given (:mock_ping) { double Fuey::Inspections::Ping }
      Given { mock_ping.should_receive(:execute).and_return true }
      Given { Fuey::Inspections::Ping.stub(:new).with("test-server", "0.0.0.1").and_return mock_ping }
      When (:result) { Fuey::Client.new.run }
      Then { expect( result ).to eql(0) }
    end

    context "when two pings are configured" do
      Given { Fuey::Config.test_with(two_pings) }
      Given (:mock_ping) { double Fuey::Inspections::Ping }
      Given { mock_ping.should_receive(:execute).twice.and_return true }
      Given { Fuey::Inspections::Ping.stub(:new).twice.and_return mock_ping }
      When (:result) { Fuey::Client.new.run }
      Then { expect( result ).to eql(0) }
    end

    context "when one vpn tunnel is configured" do
      Given { Fuey::Log.stub(:write) }
      Given { Fuey::Config.test_with(one_vpn) }
      Given (:mock_snmpwalk) { double Fuey::Inspections::SNMPWalk }
      Given { Fuey::Inspections::SNMPWalk.should_receive(:new).
        with(
             'VPN 1', '71.131.12.15', 'public', "1.2.9.2.5.3.5.7.111.0.2.0.1.0", "v1"
             ).
        and_return mock_snmpwalk }
      Given { mock_snmpwalk.should_receive(:execute).once }
      When  (:result) { Fuey::Client.new.run }
      Then  { expect( result ).to eql(0) }
    end

    context "and there is a configuration error" do
      Given { Fuey::Log.should_receive(:write).with("crap") }
      Given { Fuey::Config.stub(:inspections).and_raise(RuntimeError, "crap") }
      When  (:result) { Fuey::Client.new.run }
      Then  { expect( result ).to eql(1) }
    end
  end

  def no_inspections
    {
      "inspections" => {}
    }
  end

  def one_ping
    {
      "inspections" => {
                        "pings" => [
                          ['test-server', '0.0.0.1']
                        ]
      }
    }
  end

   def two_pings
    {
      "inspections" => {
                        "pings" => [
                                    ['test-server', '0.0.0.1'],
                                    ['vpn-tunnel', '5.5.5.5']
                        ]
      }
    }
   end

   def one_vpn
     {
       "inspections" => {
         "vpns" => [
                    {
                      "name" => "VPN 1",
                      "ip" =>  "71.131.12.15",
                      "community" => "public",
                      "oid" => "1.2.9.2.5.3.5.7.111.0.2.0.1.0",
                      "version" => "v1"
                    }
                   ]
       }
     }
   end
end
