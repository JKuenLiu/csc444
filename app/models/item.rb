class Item < ApplicationRecord
    belongs_to :person
    has_many :interactions, dependent: :destroy
    has_many_attached :photos
    has_and_belongs_to_many :tags

    validates :name, :presence => true

    def get_item_distance(current_user)
        if current_user.blank?
            return nil
        end
        if current_user
            person = Person.find_by_user_id(current_user.id)
            if person.blank?
                current_user.destroy
                return nil
            end
        end
        cur_person_location = Person.find_by_user_id(current_user.id)
        other_person_location = Person.find_by_id(self.person_id)
        distance = cur_person_location.distance_to(other_person_location, :km)
        if distance.blank?
            return nil
        end

        return distance.round(2)
    end
end
