class AddReviewerToReviews < ActiveRecord::Migration[5.2]
  def change
      add_column :reviews, :reviewer, :integer
  end
end
