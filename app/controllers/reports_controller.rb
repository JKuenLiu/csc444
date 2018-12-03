class ReportsController < ApplicationController
  before_action :require_admin
  skip_before_action :require_admin, only: [:new, :create]

  before_action :interaction_exists
  skip_before_action :interaction_exists, only: [:index, :create, :show, :update]

  def index
    @person = Person.find(params[:person_id])
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
      logger.debug "Error creating report ..."

      @report.errors.each {|s| logger.debug s}

    else

      logger.debug "Report successfully created ..."
      @complainee = Person.find(@report.reporter)
      @reported = Person.find(@report.person_id)

      puts ">>>>>>Offender is #{@offender.fname}"
      puts ">>>>>>Reported is #{@reported.fname}"
      puts ">>>>>>Reporter is #{@complainee.fname}"

    end

    redirect_to homepage_index_path
  end

  def update
    @report = Report.find(params[:id])
    @report.update(:resolved => true)

    if @report.errors.any?
      logger.debug "Error updating report ..."

      @report.errors.each {|s| logger.debug s}

    else

      logger.debug "Report successfully created ..."

    end



    redirect_to reports_path(:person_id => @report.person_id)
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

  def interaction_exists
    # render plain: find_interactions.empty?
    if find_interactions.empty?
      @person = Person.find(params[:person_id])
      @back_url = person_path(@person)
      render "no_reports.html.erb"

    else
      return true
    end

  end

  def find_interactions
    @possible_interactions = Interaction.where(:person_id => params[:person_id], :item_id => Person.find_by_user_id(current_user.id).items)
    @possible_interactions += Interaction.where(:person_id => Person.find_by_user_id(current_user.id).id, :item_id => Person.find(params[:person_id]).items)
  end

  def report_params
    params.require(:report).permit(:complaint, :reporter, :person_id)
  end

end
