FactoryBot.define do
  factory :post do
    association(:author)
    firstname { "Jane" }
    lastname { "Doe" }
    visible { true }
  end
end
