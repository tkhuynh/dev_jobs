class JobsController < ApplicationController
	before_action :find_job, only: [:show, :edit, :update, :destroy]

  def index
  	@jobs = Job.all.order("created_at DESC")
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
		params.require(:job).permit(:title, :company, :description, :url)
	end

	def find_job
		@job = Job.find(params[:id])
	end
end
