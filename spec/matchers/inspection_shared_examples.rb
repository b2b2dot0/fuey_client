shared_examples "an inspection" do
  describe "should initialize with a hash" do
    Then { expect( described_class.new({}) ).to be_a(described_class) }
  end

  describe "should respond to #execute" do
    Then { expect( described_class.new({}) ).to respond_to(:execute) }
  end

  describe "should have a name" do
    When (:inspection) { described_class.new({:name => 'hong kong fuey'} ) }
    Then { expect( inspection.name ).to eql('hong kong fuey') }
  end

  describe "should be able to produce a status represented in json" do
    Then { expect( described_class.new({}) ).to respond_to(:status) }

    describe "and have specific pieces of information" do
      When (:status) { described_class.new({:name => 'descriptive'}).status }
      Then { expect( status.type ).to eql(described_class.to_s.split('::').last) }
      And  { expect( status.name ).to eql('descriptive') }
      And  { expect( status.settings ).to_not be_nil }
      And  { expect( status.status ).to eql("pending") }
      And  { expect( status.status_message ).to_not be_nil }
    end

  end
end
