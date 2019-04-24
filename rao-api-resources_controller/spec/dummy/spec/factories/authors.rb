FactoryBot.define do
  factory :author do
    firstname { "Jane" }
    lastname { "Doe" }
    birthdate { 30.years.ago }
  end
end
