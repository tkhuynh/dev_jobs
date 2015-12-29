#see http://crestcode.com/deploying-elasticsearch-on-heroku-with-rails-4/
require 'elasticsearch/model'
 
if ENV['BONSAI_URL']
  Elasticsearch::Model.client = Elasticsearch::Client.new({url: ENV['BONSAI_URL'], logs: true})
end