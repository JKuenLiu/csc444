class Review < ApplicationRecord
  belongs_to :interaction
  belongs_to :person

  def owner
      @person
  end
end
