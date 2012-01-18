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

  describe "#items" do
    it "should respond to items" do
      @list.respond_to?(:items).should be_true
    end

    it "should persist nested items" do
      @list = FactoryGirl.create :list
      @pro  = FactoryGirl.build  :pro, list: nil
      @con  = FactoryGirl.create :con, list: @list
      @con.text = "This text is new!"
      number_of_items = @list.items.size

      @list.update_attributes(items_attributes: [@pro.attributes, @con.attributes])

      @list.items.size.should == number_of_items + 1
      @con.reload
      @con.text.should == "This text is new!"
    end
  end
end

