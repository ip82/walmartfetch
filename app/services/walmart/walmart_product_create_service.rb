module Walmart
  class WalmartProductCreateService
    attr_accessor :product_url

    def initialize(url, review_black_list)
      @product_url = url
      @review_black_list = review_black_list.split(',').map(&:strip)
    end

    def create_or_update_product
      begin
        product_data = Walmart::WalmartFetcherService.new(product_url).get_product_data
      rescue => ex
        # here we should log exception into something like New Relic
        return nil
      end

      @product = Product.find_by(walmart_id: product_data[:walmart_id]) || Product.new

      @product.walmart_id = product_data[:walmart_id]
      @product.name = product_data[:name]
      @product.price = product_data[:price]
      @product.save

      product_data[:reviews].each do |review|
        next if @product.reviews.find_by(reviewer: review[:reviewer])

        # this for sure should be optimized
        black_list_matched = false
        @review_black_list.each do |stop_word|
          black_list_matched = true if review[:body].include? stop_word
        end

        next if black_list_matched

        @product.reviews.create do |product_review|
          product_review.title = review[:title]
          product_review.submission_time = review[:submission_time]
          product_review.overall_rating = review[:overall_rating]
          product_review.reviewer = review[:reviewer]
          product_review.body = review[:body]
        end
      end

      return nil unless @product.persisted?
      @product
    end
  end
end