class ReviewsController < ApplicationController
  def index
    @owner = Person.find(params[:person_id])
    @reviews = @owner.reviews
  end

  def new
    @review = Review.new
    @reviewer = Person.find(params[:reviewer])
    @subject = Person.find(params[:subject])
    @interaction = Interaction.find(params[:interaction_id])
  end

  def create
    # render plain: params[:review].inspect
    puts "parameters for creating a review", params
    @subject = Person.find_by_id(params[:review][:subject_id])
    params = review_params
    # @owner = Person.find(params[:person_id])
    #
    subject_rating = @subject.rating

    if subject_rating
      subject_rating *= @subject.reviews.count
      subject_rating += params[:rating].to_f
      subject_rating /= @subject.reviews.count + 1
    else
      subject_rating = params[:rating]
    end

    @subject.update(:rating => subject_rating)

    @review = @subject.reviews.create(params)
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
    params.require(:review).permit(
        :comment,
        :rating,
        :interaction_id,
        :reviewer,
        :subject_id).except(:subject_id)
  end

end
