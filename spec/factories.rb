FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "tester#{n}"}
    password "testing"
  end

  factory :list do
    user
    name "Y que vamos a hacer esta noche?"
  end

  factory :item do
    list

    factory :pro do
      text "This is a good reason."
      type :pro
    end

    factory :con do
      text "This is a bad reason."
      type :con
    end
  end
end

