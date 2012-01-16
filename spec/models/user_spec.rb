require File.expand_path("spec/spec_helper")

describe User do
  before do
    @user = User.new
  end

  context "validations" do
    it "should have username and password" do
      @user = User.new
      @user.valid?.should be_false
      @user.should have(1).error_on(:username)
      @user.should have(1).error_on(:password)
    end
  end

  context "instance methods" do
    it "should respond to #lists" do
      @user.respond_to?(:lists).should be_true
    end
  end
end
