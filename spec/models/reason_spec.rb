require File.expand_path("spec/spec_helper")

describe Reason do
  before do
    @reason = Reason.new
  end

  context "validations" do
    context "#text" do
      it "should be present" do
        @reason.valid?.should be_false
        @reason.should have(1).error_on(:text)
      end
    end

    context "#type" do
      it "should be present" do
        @reason.valid?.should be_false
        @reason.should have_at_least(1).error_on(:type)
      end

      it "should be either :pro or :con" do
        @reason.type = :pro
        @reason.valid?
        @reason.should have(:no).errors_on(:type)

        @reason.type = :con
        @reason.valid?
        @reason.should have(:no).errors_on(:type)

        @reason.type = :whatev
        @reason.valid?.should be_false
        @reason.should have(1).error_on(:type)
      end
    end
  end

  context "instance methods" do
    it "should respond to dilemma" do
      @reason.respond_to?(:dilemma).should be_true
    end
  end
end
