require File.expand_path("spec/spec_helper")

describe DilemmasController do
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

    describe "GET /dilemmas" do
      it "should render the index template" do
        get :index
        response.should render_template(:index)
      end

      it "should return JSONified dilemmas if request is AJAX" do
        FactoryGirl.create(:dilemma, user: @user)

        xhr :get, :index

        response.should be_success
        body = JSON.parse response.body
        body.should have_at_least(1).item
        body.first.should have_key("name")
        body.first.should have_key("reasons")
      end
    end

    describe "POST /dilemmas" do
      before do
        @dilemma = double(to_json: {name: "new_dilemma"}.to_json)
      end

      it "should create a new dilemma" do
        Dilemma.should_receive(:create).
          with(hash_including(name: "new dilemma", user: @user)).
          and_return(@dilemma)

        post :create, name: "new dilemma"

        response.should be_success
        body = JSON.parse response.body
        body.should include("name")
      end
    end

    context "on valid dilemmas" do
      before do
        @dilemma = FactoryGirl.create :dilemma
      end

      describe "GET /dilemmas/:id/edit" do
        before do
          FactoryGirl.create :pro, dilemma: @dilemma
          FactoryGirl.create :con, dilemma: @dilemma
        end

        it "should respond with json" do
          Dilemma.should_receive(:find_by_id).with(@dilemma.id.to_s).and_return(@dilemma)

          get :edit, id: @dilemma.id

          response.code.should == "200"
          body = JSON.parse response.body
          body.should include("name")
          body.should include("reasons")
        end
      end

      describe "PUT /dilemmas/:id" do
        before do
          @pro = FactoryGirl.build :pro, dilemma: @dilemma
          @con = FactoryGirl.build :con, dilemma: nil
        end

        it "should update an existing dilemma and create all reasons" do
          Dilemma.should_receive(:find_by_id).with(@dilemma.id.to_s).and_return(@dilemma)
          @dilemma.should_receive(:update_attributes).
            with(hash_including({reasons_attributes: [@pro.attributes, @con.attributes]})).
            and_return(true)

          put :update, id: @dilemma.id, reasons: [@pro.to_json, @con.to_json]

          response.should be_success
          body = JSON.parse response.body
          body.should include("reasons")
        end
      end

      describe "DELETE /dilemmas/:id" do
        it "should delete the dilemma" do
          Dilemma.should_receive(:find_by_id).with(@dilemma.id.to_s).and_return(@dilemma)
          @dilemma.should_receive(:destroy).and_return(true)

          delete :destroy, id: @dilemma.id

          response.should be_success
        end
      end
    end
  end
end

