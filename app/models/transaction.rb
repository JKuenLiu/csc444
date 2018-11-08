class Transaction < ApplicationRecord
	enum status: [:requested, :approved, :returned]
	has_many :reviews
end
