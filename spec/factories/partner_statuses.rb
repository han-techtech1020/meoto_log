FactoryBot.define do
  factory :partner_status do
    hp_percentage { 80 }
    mood_id { 1 }
    association :user
  end
end
