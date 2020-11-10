FactoryBot.define do
  factory :idea do
    trait :a do
      id { 1 }
      category_id { 1 }
      body { 'work' }
    end

    trait :b do
      id { 2 }
      category_id { 2 }
      body { 'run' }
    end

    trait :c do
      id { 3 }
      category_id { 2 }
      body { 'walk' }
    end
  end
end