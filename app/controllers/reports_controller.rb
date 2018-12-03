class ReportsController < ApplicationController
  before_action :require_admin

  skip_before_action :require_admin, only: [:new, :create]

  def index
    @person = Person.find_by(params[:person_id])
    @reports = @person.reports
  end

  def new
    @report = Report.new
    @person = Person.find(params[:person_id])
  end

  def create
    # render plain: params[:review].inspect
    params = report_params
    @offender = Person.find(params[:person_id])

    @report = @offender.reports.create(params.except(:person_id))

    if @report.errors.any?
      logger.debug "Error creating review ..."

      @report.errors.each {|s| logger.debug s}

    else

      logger.debug "Review successfully created ..."

    end

    redirect_to homepage_index_path
  end

  def show

  end

  def require_admin

    if current_user.admin
        return true
    else
      redirect_to homepage_index_path
    end

  end

  def report_params
    params.require(:report).permit(:complaint, :reporter, :person_id)
  end

end
