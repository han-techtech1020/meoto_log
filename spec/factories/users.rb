# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    # Fakerを使ってランダムなデータを生成
    nickname { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
