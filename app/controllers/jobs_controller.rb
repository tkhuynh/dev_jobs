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
  	@job = Job.new
  end

  def create
  	@job = Job.new(job_params)
  	if @job.save
  		redirect_to job_path(@job)
  	else
  		redirect_to new_job_path
  	end
  end

  def edit
  end

  def update
  	if @job.update_attributes(job_params)
  		redirect_to job_path(@job)
  	else
  		redirect_to edit_job_path
  	end
  end

  def destroy
  	@job.destroy
  	redirect_to jobs_path
  end

private
	
	def job_params
		params.require(:job).permit(:title, :company, :description, :url, :category_id)
	end

	def find_job
		@job = Job.find(params[:id])
	end
end
