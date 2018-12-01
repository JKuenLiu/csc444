class AddPeopleToReviews < ActiveRecord::Migration[5.2]
  def change
    add_reference :reviews, :person, foreign_key: true
  end
end
