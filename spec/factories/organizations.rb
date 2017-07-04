require "ffaker"

FactoryGirl.define do
  factory :organization do
    name "Framgia"
    display_name {FFaker::Name}
    creator_id 1
    slug 1
  end
end
