class Person < ApplicationRecord
    belongs_to :user
    has_many :items, dependent: :destroy
    has_one_attached :avatar

    validates :fname,:presence => true
    validates :lname, :presence => true
    validates :street,:presence => true
    validates :city, :presence => true
    validates :province,:presence => true
    validates :country, :presence => true
end
