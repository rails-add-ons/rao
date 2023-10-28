FactoryBot.define do
  factory :post do
    sequence(:title) { |i| "Post #{i}" }
  end
end
