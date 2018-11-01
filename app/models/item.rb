class Item < ApplicationRecord
    belongs_to :person
    has_many_attached :photos
end
