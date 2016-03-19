# require 'elasticsearch/model'

class Article < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

 	# def self.search(query)
  # 	__elasticsearch__.search(
  #   	{
  #     	query: {
  #       	multi_match: {
  #         		query: query,
  #         		fields: ['title^10', 'text']
  #       	}
  #     	}
  #   }
  # 	)
 	# end
end

Article.import force: true # for auto sync model with elastic search