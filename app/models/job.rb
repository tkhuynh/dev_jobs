class Job < ActiveRecord::Base
	belongs_to :category
	belongs_to :user

	validates :title, presence: true, length: { minimum: 10 }
	validates :company, presence: true
	validates :description, presence: true, length: { minimum: 10 }
	validates :url, presence: true
	validates :category_id, presence: true
	validates :location, presence: true

end
