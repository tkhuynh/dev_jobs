class Job < ActiveRecord::Base
	belongs_to :category
	belongs_to :user

	# see http://www.rubydoc.info/gems/elasticsearch-model/Elasticsearch/Model/Callbacks
	include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

	validates :title, presence: true
	validates :company, presence: true
	validates :description, presence: true, length: { minimum: 10 }
	validates :url, presence: true
	validates :category_id, presence: true
	validates :location, presence: true

end