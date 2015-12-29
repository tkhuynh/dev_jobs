class JobsController < ApplicationController
	before_action :find_job, only: [:show, :edit, :update, :destroy]

  def index
    # if an Indeed search performed show search result in job index view
    if params[:q]. present? 
      @search = true
      # see indeed API gem documentation https://github.com/seejohnrun/indeed_api
      # search result which is @jobs is an Array
      # will pagination won't work with Array unless we tell Rails to require it
      # see file config/initializers/will_paginate_array_also.rb
      job_type = params[:jt].sub(/\s/, "") #remove space for full time and part time 
      @jobs = IndeedAPI.search_jobs(q: params[:q], l: params[:l], jt: job_type, limit: 25).results.paginate(page: params[:page], per_page: 5)
      puts job_type
    else # if no Indeed search performed show users posted jobs
      # if user don't click on filter link
    	if params[:category].blank?
        if params[:query].present? # if a bulletin search performed
          @bulletin_search = true
          # search results as records 
          # https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/_activemodel_activerecord.html
    		  @jobs = Job.search(params[:query]).records.paginate(page: params[:page], per_page: 5)
        else
          @jobs = Job.all.order("created_at DESC").paginate(page: params[:page], per_page: 5)
        end
    	else 
        # when user click on filter link
        # find category chosen then get the category_id
    		@category_id = Category.find_by(name: params[:category]).id
        # filter the job base on categery_id
    		@jobs = Job.where(category_id: @category_id).order("created_at DESC").paginate(page: params[:page], per_page: 5)
    	end
    end

  end

  def show
  end

  def new
    #don't let non logged in user see new job form
    if current_user
      @job = Job.new
    else
      flash[:error] = "Please signup or login to post a job."
      redirect_to login_path
    end
  end

  def create
    #prevent non logged in user to create new job
    if current_user
    	@job = current_user.jobs.new(job_params)
    	if @job.save
        flash[:notice] = "New job is sucessfully posted."
    		redirect_to job_path(@job)
    	else
        flash[:error] = @job.errors.full_messages.join(', ')
    		redirect_to new_job_path
    	end
    else
      redirect_to login_path
    end
  end

  def edit
    #prevent non logged in user to see edit job form
    unless current_user == @job.user
      flash[:error] = "You can't edit other user's posted job."
      redirect_to job_path(@job)
    end
  end

  def update
    #prevent non logged in user to edit job
    if current_user == @job.user
    	if @job.update_attributes(job_params)
        flash[:notice] = "Sucessfully edited job."
    		redirect_to job_path(@job)
    	else
        flash[:error] = @job.errors.full_messages.join(', ')
    		redirect_to edit_job_path
    	end
    else
      redirect_to job_path(@job)
    end
  end

  def destroy
    if current_user == @job.user
    	@job.destroy
      flash[:notice] = "Sucessfully deleted your posted job."
    	redirect_to jobs_path
    else
      redirect_to job_path(@job)
    end
  end

private
	
	def job_params
		params.require(:job).permit(:title, :company, :description, :url, :category_id, :location)
	end

	def find_job
		@job = Job.find(params[:id])
	end
end
