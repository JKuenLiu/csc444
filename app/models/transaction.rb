class Transaction < ApplicationRecord
	# The person id is always the initial requestor
	# Can get owner id via the item
	enum status: [:requested, :approved, :returned]

	has_many :reviews

	def destroy
	end

end
