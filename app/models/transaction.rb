class Transaction < ApplicationRecord
	enum status: [:requested, :approved, :returned]

	has_many :reviews

	def destroy
	end

end
