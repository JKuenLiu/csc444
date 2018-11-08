class Transaction < ApplicationRecord
	enum status: [:requested, :approved, :returned]
end
