FactoryBot.define do
    factory :user do
        email { "p@p.com" }
        password { "asdfgh" }
    end
    factory :person do
        fname { "p0" }
        lname { "lp0" }
        phone { }
        user_id { 0 }
        rating { 0 }
        street { "sc" }
        city { "New York" }
        province { "NY" }
        country { "United States" }
        postal_code { "" }
        address { "New York, NY, USA" }
        latitude { }
        longitude { }
        association :user
    end
    factory :item do
        name { "i0" }
        description { "in good quality" }
        category { "Books" }
        status {}
        owner {}
        current_holder { "1" }
        person_id { 0 }
        association :person
    end
    factory :interaction do
        person_id { 1 }
        status { :requested }
        start_date { Date.today }
        end_date { Date.today + 3 }
        item_id { 0 }
        association :item
    end
end
