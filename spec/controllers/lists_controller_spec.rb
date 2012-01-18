require File.expand_path("spec/spec_helper")

describe ListsController do
  context "non authenticated requests" do
    it "should not be accepted" do
      get :index
      response.should_not be_success
    end
  end

  context "authenticated requests" do
    before do
      @user = FactoryGirl.create(:user)
      login_user @user
    end

    describe "GET /lists" do
      it "should render the index template" do
        get :index
        response.should render_template(:index)
      end
    end

    describe "POST /lists" do
      before do
        @list = double(to_json: {name: "new_list"}.to_json)
      end

      it "should create a new list" do
        List.should_receive(:create).
          with(hash_including(name: "new list", user: @user)).
          and_return(@list)

        post :create, name: "new list"

        response.should be_success
        body = JSON.parse response.body
        body.should include("name")
      end
    end

    context "on valid lists" do
      before do
        @list = FactoryGirl.create :list
      end

      describe "GET /lists/:id/edit" do
        before do
          FactoryGirl.create :pro, list: @list
          FactoryGirl.create :con, list: @list
        end

        it "should respond with json" do
          List.should_receive(:find_by_id).with(@list.id.to_s).and_return(@list)

          get :edit, id: @list.id

          response.code.should == "200"
          body = JSON.parse response.body
          body.should include("name")
          body.should include("items")
        end
      end

      describe "PUT /lists/:id" do
        before do
          @pro = FactoryGirl.build :pro, list: @list
          @con = FactoryGirl.build :con, list: nil
        end

        it "should update an existing list and create all items" do
          List.should_receive(:find_by_id).with(@list.id.to_s).and_return(@list)
          @list.should_receive(:update_attributes).
            with(hash_including({items_attributes: [@pro.attributes, @con.attributes]})).
            and_return(true)

          put :update, id: @list.id, items: [@pro.to_json, @con.to_json]

          response.should be_success
          body = JSON.parse response.body
          body.should include("items")
        end
      end

      describe "DELETE /lists/:id" do
        it "should delete the list" do
          List.should_receive(:find_by_id).with(@list.id.to_s).and_return(@list)
          @list.should_receive(:destroy).and_return(true)

          delete :destroy, id: @list.id

          response.should be_success
        end
      end
    end
  end
end

