class Transaction < ApplicationRecord
	enum status: [:requested, :approved, :returned]

	def destroy

	end
end
