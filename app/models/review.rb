class Review < ApplicationRecord
  belongs_to :interaction

  def owner
      @person
  end
end
