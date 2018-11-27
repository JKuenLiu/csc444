class ReviewsController < ApplicationController
  def index
  end

  def new
    @review = Review.new
    @person = Person.find(params[:person_id])
    @interaction = Interaction.find(params[:interaction_id])
    @item = Item.find(params[:item_id])
  end

  def create

    @review = Review.create(review_params)

    if @review.errors.any?
      logger.debug "Error creating review ..."

      @review.errors.each {|s| logger.debug s}

      redirect_to homepage_index_path
    else
      logger.debug "Review successfully created ..."
      redirect_to homepage_index_path
    end

  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating, :interaction_id)
  end

end
