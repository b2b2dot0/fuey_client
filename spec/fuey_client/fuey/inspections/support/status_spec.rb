require 'spec_helper'

describe Fuey::Inspections::Support::Status do

  describe "attributes" do
    Then { expect( subject ).to respond_to(:type) }
    Then { expect( subject ).to respond_to(:name) }
    Then { expect( subject ).to respond_to(:status) }
    Then { expect( subject ).to respond_to(:settings) }
    Then { expect( subject ).to respond_to(:status_message) }
  end

  describe "passed?" do
    Given (:status) { Fuey::Inspections::Support::Status.new :status => 'passed' }
    Then  { expect( status ).to be_passed }
    Then  { expect( status ).to_not be_failed }
  end

  describe "failed?" do
    Given (:status) { Fuey::Inspections::Support::Status.new :status => 'failed' }
    Then  { expect( status ).to_not be_passed }
    Then  { expect( status ).to be_failed }
  end

  describe "equality" do
    Given (:attributes) { { :name => "Status 1", :status => "pending", :type => "Inspection" } }

    context "when both have same attributes" do
      Given (:status1) { Fuey::Inspections::Support::Status.new attributes.clone }
      Given (:status2) { Fuey::Inspections::Support::Status.new attributes.clone }
      Then  { expect( status1 ).to eq( status2 ) }
    end

    context "when both have same values, but one has additional key with a nil value" do
      Given (:status1) { Fuey::Inspections::Support::Status.new attributes.clone }
      Given (:status2) { Fuey::Inspections::Support::Status.new attributes.clone.merge({:settings => nil}) }
      Then  { expect( status1 ).to eq( status2 ) }
    end

    context "when both only have a different status" do
      Given (:status1) { Fuey::Inspections::Support::Status.new attributes.clone }
      Given (:status2) { Fuey::Inspections::Support::Status.new attributes.clone.merge({:status => 'failed'}) }
      Then  { expect( status1 ).to_not eq( status2 ) }
    end

    context "when both only have a different name" do
      Given (:status1) { Fuey::Inspections::Support::Status.new attributes.clone }
      Given (:status2) { Fuey::Inspections::Support::Status.new attributes.clone.merge({:name => 'Status X'}) }
      Then  { expect( status1 ).to_not eq( status2 ) }
    end
  end


end
