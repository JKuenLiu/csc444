class Review < ApplicationRecord
  belongs_to :interaction, foreign_key: "transaction_id", class_name: "Transaction"
end
