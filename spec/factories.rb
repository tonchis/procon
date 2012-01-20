FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "tester#{n}"}
    password "testing"
  end

  factory :dilemma do
    user
    name "Gee Brain, what do you wanna do tonight?"
  end

  factory :item do
    dilemma

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

