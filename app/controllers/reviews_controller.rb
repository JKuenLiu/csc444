class ReviewsController < ApplicationController
  def index
    @owner = Person.find(params[:person_id])
    @reviews = @owner.reviews
  end

  def new
    @review = Review.new
    @person = Person.find(params[:person_id])
    @interaction = Interaction.find(params[:interaction_id])
    @item = Item.find(params[:item_id])
    @owner = Person.find(@item.person_id)
  end

  def create
    # render plain: params[:review].inspect
    params = review_params
    @owner = Person.find(params[:person_id])

    owner_rating = @owner.rating

    if owner_rating
      owner_rating += params[:rating].to_f
      owner_rating /= 2.0
    else
      owner_rating = params[:rating]
    end

    @owner.update(:rating => owner_rating)

    @review = @owner.reviews.create(params.except(:person_id))

    if @review.errors.any?
      logger.debug "Error creating review ..."

      @review.errors.each {|s| logger.debug s}

    else

      logger.debug "Review successfully created ..."

    end

    redirect_to homepage_index_path
  end

  private

  def review_params
    params.require(:review).permit(:comment, :rating, :interaction_id, :person_id)
  end

end
