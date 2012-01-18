require File.expand_path("spec/spec_helper")

describe ListsController do
  before do
    @user = User.create username: "test", password: "test"
  end

  context "authentication" do
    it "should forbid requests without authentication" do
      get :index
      puts response
    end
  end
end
