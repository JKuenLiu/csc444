class Person < ApplicationRecord
    belongs_to :user
    has_many :items, dependent: :destroy
    has_one_attached :avatar
end
