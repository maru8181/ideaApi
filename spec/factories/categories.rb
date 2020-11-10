FactoryBot.define do
  factory :category do
    trait :a do
      id { 1 }
      name { 'money' }
    end

    trait :b do
      id { 2 }
      name { 'sports' }
    end
  end
end