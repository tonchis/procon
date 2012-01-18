require File.expand_path("spec/spec_helper")

describe ListsController do
  before(:each) do
    @user = User.create username: "test", password: "test"
  end

  context "authentication" do
    it "should forbid requests without authentication" do
      get :index
      response.code.should_not == "200"
    end
  end

  describe "GET /lists" do
    before do
      login_user(@user)
    end

    it "should render the index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "POST /lists" do
    before do
      login_user(@user)
      List.should_receive(:create).with(name: "new list", user: @user).
        and_return({name: "new list"})
    end

    it "should create a new list" do
      post :create, name: "new list"
      response.code.should == "200"
      response.body.should match(/\"name\":"new list\"/)
    end
  end
end
