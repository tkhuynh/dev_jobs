class JobsController < ApplicationController
	before_action :find_job, only: [:show, :edit, :update, :destroy]

  def index
    # if user don't click on filter link
  	if params[:category].blank?
  		@jobs = Job.all.order("created_at DESC")
  	else 
      # when user click on filter link
      # find category chosen then get the category_id
  		@category_id = Category.find_by(name: params[:category]).id
      # filter the job base on categery_id
  		@jobs = Job.where(category_id: @category_id).order("created_at DESC")
  	end
  end

  def show
  end

  def new
    #don't let non logged in user see new job form
    if current_user
      @job = Job.new
    else
      redirect_to login_path
    end
  end

  def create
    #prevent non logged in user to create new job
    if current_user
    	@job = current_user.jobs.new(job_params)
    	if @job.save
    		redirect_to job_path(@job)
    	else
    		redirect_to new_job_path
    	end
    else
      redirect_to login_path
    end
  end

  def edit
    #prevent non logged in user to see edit job form
    unless current_user == @job.user
      redirect_to job_path(@job)
    end
  end

  def update
    #prevent non logged in user to edit job
    if current_user == @job.user
    	if @job.update_attributes(job_params)
    		redirect_to job_path(@job)
    	else
    		redirect_to edit_job_path
    	end
    else
      redirect_to job_path(@job)
    end
  end

  def destroy
    if current_user == @job.user
    	@job.destroy
    	redirect_to jobs_path
    else
      redirect_to job_path(@job)
    end
  end

private
	
	def job_params
		params.require(:job).permit(:title, :company, :description, :url, :category_id)
	end

	def find_job
		@job = Job.find(params[:id])
	end
end
