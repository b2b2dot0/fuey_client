require "spec_helper"

describe Fuey::Client do
  after(:each) { Fuey::Config.reload_configuration }

  describe "#initialize" do
    context "passing a configuration path" do
      Given { Configurethis.should_receive(:root_path=).with('path/to/dir') }
      When (:result) { Fuey::Client.new 'path/to/dir', [] }
      Then { expect( result ).to be_a(Fuey::Client) }
    end

    context "passing an array of notification settings" do
      Given { ActiveSupport::Notifications.should_receive(:subscribe).with("ping", an_instance_of(Fuey::Log)) }
      Given { ActiveSupport::Notifications.should_receive(:subscribe).with("snmp", an_instance_of(Fuey::Log)) }
      When  (:result) { Fuey::Client.new '', [["ping", "Fuey::Log"], ["snmp","Fuey::Log"]] }
      Then  { expect( result ).to be_a(Fuey::Client) }
    end
  end

end
