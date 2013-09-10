require 'spec_helper'

describe Fuey::Inspections::Inspection do

  def successful_inspection
    Class.new(Fuey::Inspections::Inspection) do
      def _execute
        self.pass
      end
    end
  end

  def failed_inspection
    Class.new(Fuey::Inspections::Inspection) do
      def _execute
        self.fail
      end
    end
  end

  class InspectionObserver
    def initialize(inspection)
      @inspection = inspection
      @inspection.add_observer self
    end

    def update; end

    def expects_notification_of(*states)
      states.each do |state|
        self.should_receive(:update).
          with(Fuey::Inspections::Support::Status.new(
                                                      :type => @inspection.class.to_s,
                                                      :name => @inspection.name,
                                                      :status => state,
                                                      :settings => nil,
                                                      :status_message => nil
                                                      )
               )
      end
    end
  end

  describe "observing execution" do
    context "when it fails" do
      Given(:inspection) { failed_inspection.new({ :name => 'Example' }) }
      Given(:subscriber) { InspectionObserver.new(inspection) }
      Given { subscriber.expects_notification_of('pending', 'executed', 'failed') }
      When  { inspection.execute }
      Then  { expect( inspection ).to be_failed }
    end

    context "when it passes" do
      Given(:inspection) { successful_inspection.new({ :name => 'Example' }) }
      Given(:subscriber) { InspectionObserver.new(inspection) }
      Given { subscriber.expects_notification_of('pending', 'executed', 'passed') }
      When  { inspection.execute }
      Then  { expect( inspection ).to be_passed }
    end
  end

  describe "it's state" do
    Given (:inspection) { Fuey::Inspections::Inspection.new }

    context "initially" do
      Then { expect( inspection.state ).to eql('pending') }
    end

    context "when the inspection passes" do
      When  { inspection.pass }
      Then  { expect( inspection ).to be_passed }
    end

    context "when the inspection fails" do
      When  { inspection.fail }
      Then  { expect( inspection ).to be_failed }
    end
  end
end
