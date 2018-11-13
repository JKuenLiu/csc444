class Item < ApplicationRecord
    belongs_to :person
    has_many_attached :photos
    has_and_belongs_to_many :tags

    validates :name, :presence => true

    #validates :start_date,:presence => true
    #validates :end_date, :presence => true
    validate :start_date_cannot_be_in_the_past,
             :start_date_cannot_be_later_than_end_date
    #validates_format_of :start_date, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "Start date must be added."
    #validates_format_of :end_date, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "End date must be added."


    def start_date_cannot_be_in_the_past
        if start_date and start_date < Date.today
            errors.add(:start_date, "can't be in the past");
        end
    end

    def start_date_cannot_be_later_than_end_date
        if start_date and end_date and start_date > end_date
            errors.add(:start_date, "can't be past end date");
        end
    end
end
