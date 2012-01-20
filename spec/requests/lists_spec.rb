require File.expand_path("spec/spec_helper")

feature "Pros and Cons Lists" do
  background {login}

  # scenario "Creating a new list", js: true do
    # visit root_path
    # page.should have_content("Pros and Cons lists!")
    # within "#new-list-form" do
      # fill_in "name", with: "brand new list!"
      # click_button "Add!"
    # end

    # within "ul#lists" do
      # page.should have_content("brand new list!")
    # end
  # end
end
