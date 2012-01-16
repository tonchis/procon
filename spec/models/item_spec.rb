require File.expand_path("spec/spec_helper")

describe Item do
  before do
    @item = Item.new
  end

  context "validations" do
    context "#text" do
      it "should be present" do
        @item.valid?.should be_false
        @item.should have(1).error_on(:text)
      end
    end

    context "#type" do
      it "should be present" do
        @item.valid?.should be_false
        @item.should have_at_least(1).error_on(:type)
      end

      it "should be either :pro or :con" do
        @item.type = :pro
        @item.valid?
        @item.should have(:no).errors_on(:type)

        @item.type = :con
        @item.valid?
        @item.should have(:no).errors_on(:type)

        @item.type = :whatev
        @item.valid?.should be_false
        @item.should have(1).error_on(:type)
      end
    end
  end

  context "instance methods" do
    it "should respond to list" do
      @item.respond_to?(:list).should be_true
    end
  end
end
