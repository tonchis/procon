module RequestsHelpers
  def login
    user = FactoryGirl.create :user
    visit root_path
    fill_in "username", with: user.username
    fill_in "password", with: "testing"
    click_button "Sign in"
  end
end

