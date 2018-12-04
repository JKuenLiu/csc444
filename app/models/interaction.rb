class Interaction < ApplicationRecord
	# The person id is always the initial requestor
	# Can get owner id via the item
	enum status: [:requested, :approved, :returned, :available, :failed]

    belongs_to :item
	  has_one :review

    validates :start_date,:presence => true
    validates :end_date, :presence => true
    validate :start_date_cannot_be_in_the_past,
             :start_date_cannot_be_later_than_end_date


    def start_date_cannot_be_in_the_past
        if start_date and start_date < Date.today
            errors.add(:start_date, "can't be in the past")
        end
    end

    def start_date_cannot_be_later_than_end_date
        if start_date and end_date and start_date > end_date
            errors.add(:start_date, "can't be after end date")
        end
    end

	def destroy
	end

end
