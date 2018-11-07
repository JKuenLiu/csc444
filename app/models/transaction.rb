class Transaction < ApplicationRecord
	enum status: [:requested, :approved, :lent]
end
