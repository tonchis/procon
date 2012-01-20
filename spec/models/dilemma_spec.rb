require File.expand_path("spec/spec_helper")

describe Dilemma do
  before do
    @dilemma = Dilemma.new
  end

  context "validations" do
    describe "#name" do
      it "should be present" do
        @dilemma.valid?.should be_false
        @dilemma.should have(1).error_on(:name)
      end
    end
  end

  describe "#items" do
    it "should respond to items" do
      @dilemma.respond_to?(:items).should be_true
    end

    it "should persist nested items" do
      @dilemma = FactoryGirl.create :dilemma
      @pro  = FactoryGirl.build  :pro, dilemma: nil
      @con  = FactoryGirl.create :con, dilemma: @dilemma
      @con.text = "This text is new!"
      number_of_items = @dilemma.items.size

      @dilemma.update_attributes(items_attributes: [@pro.attributes, @con.attributes])

      @dilemma.items.size.should == number_of_items + 1
      @con.reload
      @con.text.should == "This text is new!"
    end
  end
end

