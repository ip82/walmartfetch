require 'net/http'

module Walmart
  class WalmartFetcherService
    class WalmartFetcherError < StandardError
    end

    attr_accessor :product_review_url, :config, :walmart_id

    def initialize(url)
      @config = YAML::load_file(Rails.root.join('config/walmart.yml'))
      begin
        @product_review_url = api_product_review_url(url)
      rescue => ex
        raise WalmartFetcherError, ex.message
      end
    end

    def get_product_data
      begin
        response = JSON.parse Net::HTTP.get(product_review_url)
        {
          walmart_id: @walmart_id,
          name: response['name'],
          price: (response['salePrice'].to_f*100).to_i,
          reviews: response['reviews'].map{|review| {
                                          overall_rating: review['overallRating']['rating'], 
                                          reviewer:review['reviewer'], 
                                          body: review['reviewText'], 
                                          title: review['title'],
                                          submission_time: review['submissionTime']
                                          }
                                        }
        }
      rescue => ex
        raise WalmartFetcherError, "can't get product data, url: #{product_review_url}, message: #{ex.message}"
      end
    end

    private
    def api_product_review_url(url)
      # we need to extract "product id" from given url, it's either at the end of the string or followed by "?"
      item_id = /(\d){8,}(\?|$)/.match(url).try(:to_s)
      raise WalmartFetcherError, "walmart fetcher, wrong url #{url}" unless item_id

      item_id.gsub! '?',''
      @walmart_id = item_id

      URI.parse "http://api.walmartlabs.com/v1/reviews/#{@walmart_id}?format=json&apiKey=#{@config['api_key']}"
    end
  end
end
