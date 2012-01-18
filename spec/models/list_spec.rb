require File.expand_path("spec/spec_helper")

describe List do
  before do
    @list = List.new
  end

  context "validations" do
    describe "#name" do
      it "should be present" do
        @list.valid?.should be_false
        @list.should have(1).error_on(:name)
      end
    end
  end

  context "instance methods" do
    it "should respond to items" do
      @list.respond_to?(:items).should be_true
    end

    context "scopes" do
      before do
        @list = FactoryGirl.create(:list)
        @pro = FactoryGirl.create(:pro, list: @list)
        @con = FactoryGirl.create(:con, list: @list)
      end

      describe "#pros" do
        it "should contain only items of type :pro" do
          @list.pros.should     include(@pro)
          @list.pros.should_not include(@con)
        end
      end

      describe "#cons" do
        it "should contain only items of type :con" do
          @list.cons.should_not include(@pro)
          @list.cons.should     include(@con)
        end
      end
    end
  end
end

