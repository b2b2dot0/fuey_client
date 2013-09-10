require 'spec_helper'

describe Fuey::Inspections::RFCPing do
  it_behaves_like "an inspection"

  Given (:config) {
    {
      'ashost' => '1.0.0.1',
      'sysnr' => "00",
      'client' => "400",
      'user' => 'chud',
      'passwd' => 'gobrowns',
      'lang' => 'EN'
    }
  }
  Given (:rfc_ping) { Fuey::Inspections::RFCPing.new config }

  describe "status" do
    Then { expect( rfc_ping.status.settings ).to_not include('passwd') }
  end

  context "when the ping fails" do
    Given (:conn) { double Fuey::Inspections::Support::SAP }
    Given { Fuey::Inspections::Support::SAP.should_receive(:new).with(config).and_return(conn) }
    Given { conn.stub(:ping).and_return([false, "RFC Ping failure msg"]) }
    When  { rfc_ping.execute }
    Then  { expect( rfc_ping ).to have_aborted }
    And   { expect( rfc_ping.status_message ).to end_with("RFC Ping failure msg") }
  end

  context "when the ping succeeds" do
    Given (:conn) { double Fuey::Inspections::Support::SAP }
    Given { Fuey::Inspections::Support::SAP.should_receive(:new).with(config).and_return(conn) }
    Given { conn.stub(:ping).and_return([true, ""]) }
    When  { rfc_ping.execute }
    Then  { expect( rfc_ping ).to have_passed }
    And   { expect( rfc_ping.status_message ).to eql("RFCPing passed for 1.0.0.1.") }
  end
end
