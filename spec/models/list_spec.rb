require File.expand_path("spec/spec_helper")

describe List do
  context "validations" do
    context "#name" do
      it "should be present" do
        @list = List.new
        @list.valid?.should be_false
        @list.should have(1).error_on(:name)
      end
    end
  end
end

