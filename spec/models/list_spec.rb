require File.expand_path("spec/spec_helper")

describe List do
  before do
    @list = List.new
  end

  context "validations" do
    context "#name" do
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
        @list.user = User.create username: "test", password: "test"
        @list.name = "Testing, good or bad?"
        @pro = Item.create(text: "Makes you happy.", list: @list, type: :pro)
        @con = Item.create(text: "It takes time.",   list: @list, type: :con)
      end

      context "#pros" do
        it "should contain only items of type :pro" do
          @list.pros.should include @pro
          @list.pros.should_not include @con
        end
      end

      context "#cons" do
        it "should contain only items of type :con" do
          @list.cons.should_not include @pro
          @list.cons.should include @con
        end
      end
    end
  end
end

