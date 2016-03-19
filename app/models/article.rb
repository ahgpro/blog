# require 'elasticsearch/model'

class Article < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

   	def self.search(query)
    	__elasticsearch__.search(
      	{
        	query: {
          	multi_match: {
            		query: query,
            		fields: ['title^10', 'text']
          	}
        	},
          highlight: {
            pre_tags: ['<em>'],
            post_tags: ['</em>'],
            fields: {
              title: {},
              text: {}
            }
          }
        }
    	)
   	end

    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :title, analyzer: 'english'
        indexes :text, analyzer: 'english'
      end
    end
end

# Delete the previous articles index in Elasticsearch
Article.__elasticsearch__.client.indices.delete index: Article.index_name rescue nil

# Create the new index with the new mapping
Article.__elasticsearch__.client.indices.create \
  index: Article.index_name,
  body: { settings: Article.settings.to_hash, mappings: Article.mappings.to_hash }

# for auto sync model with elastic search
Article.import force: true