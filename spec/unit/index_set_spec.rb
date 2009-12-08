require File.expand_path("../../spec_helper", __FILE__)

describe "Friendly::IndexSet" do
  before do
    @klass       = stub
    @index       = stub
    @index_klass = stub(:new => @index)
    @set         = Friendly::IndexSet.new(@klass, @index_klass)
  end

  describe "doing a `first`" do
    before do
      @id     = stub
      @index  = stub(:satisfies? => true, :first => @id)
      @set << @index
    end

    describe "when there's an index that matches the conditions" do
      before do
        @result = @set.first(:name => "x")
      end

      it "delegates to the index that satisfies the conditions" do
        @index.should have_received(:first).once
        @index.should have_received(:first).with(:name => "x")
      end

      it "returns id" do
        @result.should == @id
      end
    end

    describe "when there's no index that matches" do
      before do
        @index.stubs(:satisfies?).returns(false)
      end

      it "raises MissingIndex" do
        lambda {
          @set.first(:name => "x")
        }.should raise_error(Friendly::MissingIndex)
      end
    end
  end

  describe "doing an `all`" do
    before do
      @ids    = [stub]
      @index  = stub(:satisfies? => true, :all => @ids)
      @set << @index
    end

    describe "when there's an index that matches the conditions" do
      before do
        @result = @set.all(:name => "x")
      end

      it "delegates to the index that satisfies the conditions" do
        @index.should have_received(:all).once
        @index.should have_received(:all).with(:name => "x")
      end

      it "returns the results" do
        @result.should == @ids
      end
    end

    describe "when there's no index that matches" do
      before do
        @index.stubs(:satisfies?).returns(false)
      end

      it "raises MissingIndex" do
        lambda {
          @set.all(:name => "x")
        }.should raise_error(Friendly::MissingIndex)
      end
    end
  end

  describe "adding an index to the set" do
    before do
      @set.add(:name, :age)
    end

    it "creates an index" do
      @index_klass.should have_received(:new).once
      @index_klass.should have_received(:new).with(@klass, :name, :age)
    end

    it "adds the index to the set" do
      @set.should include(@index)
    end
  end
end
