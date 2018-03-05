# frozen_string_literal: true

FactoryBot.define do
  factory :short_url do
    short_address { "1" }
    factory :short_url_with_targets do
      after(:create) do |short_url, _evaluator|
        create_list(:url, 1, short_url: short_url)
      end
    end
  end
  factory :url do
    id { 1 }
    full_address { "https://jooraccess.com/" }
    device_type { "desktop" }
  end
end
