class HomepageController < ApplicationController
    skip_before_action :require_login
    before_action :require_login, only: [:notifications, :history]

    def index
        @all_items = Array.new
         if params[:term]
             @all_items = Item.where('name LIKE ?', "%#{params[:term]}%")
             Tag.where('name LIKE ?', "%#{params[:term]}%").each do|tag|
                 @all_items += tag.items.select{|item|!@all_items.include? item}
             end
         else
             @all_items = Item.all
         end
         # @five_star_reviews = find_five_star_reviews
         # @five_star_review_users = get_five_star_review_users
    end

    def history
        @person = Person.find_by_user_id(current_user.id)
        @items = @person.items
        @interactions = Interaction.where(item_id: @items.map(&:id)).order(date: :desc)
    end

    ##############################################
    ##############PRIVATE FUNCTIONS###############
    ##############################################
    private
    # def find_five_star_reviews
    #     five_star_reviews = Review.where(rating: 5.0).last(3)
    #     if five_star_reviews.blank?
    #         return nil
    #     else
    #         return five_star_reviews
    #     end
    # end
    #
    # def get_five_star_review_users
    #     five_star_reviews = find_five_star_reviews
    #     reviewers = []
    #     if five_star_reviews.blank?
    #         return nil
    #     else
    #         five_star_reviews.each do |review|
    #             interaction = Interaction.find_by_id(review.interaction_id)
    #             person = Person.find_by_id(interaction.person_id)
    #             reviewers.push(person)
    #         end
    #         return reviewers
    #     end
    # end
end
