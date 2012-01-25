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

  context "instance methods" do
    it "should respond to reasons" do
      @dilemma.respond_to?(:reasons).should be_true
    end

    describe "#reasons" do
      it "should persist nested reasons" do
        @dilemma = FactoryGirl.create :dilemma
        @pro  = FactoryGirl.build  :pro, dilemma: nil
        @con  = FactoryGirl.create :con, dilemma: @dilemma
        @con.text = "This text is new!"
        number_of_reasons = @dilemma.reasons.size

        @dilemma.update_attributes(reasons_attributes: [@pro.attributes, @con.attributes])

        @dilemma.reasons.size.should == number_of_reasons + 1
        @con.reload
        @con.text.should == "This text is new!"
      end
    end
  end
end

