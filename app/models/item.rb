class Item < ApplicationRecord
    belongs_to :person
    has_many_attached :photos
    has_and_belongs_to_many :tags

    validates :name, :presence => true
end
