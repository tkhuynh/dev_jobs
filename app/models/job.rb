class Job < ActiveRecord::Base
	belongs_to :category
	belongs_to :user

	include Tire::Model::Search # search and indexing method
  include Tire::Model::Callbacks # callback to update indexing when create, edit or destroy
  # after adding 2 model above
  # run command in terminal: rake environment tire:import:all
  # to index all the jobs

	validates :title, presence: true, length: { minimum: 10 }
	validates :company, presence: true
	validates :description, presence: true, length: { minimum: 10 }
	validates :url, presence: true
	validates :category_id, presence: true
	validates :location, presence: true

end
