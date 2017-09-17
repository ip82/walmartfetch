require 'rails_helper'

describe Walmart::WalmartProductCreateService do
  let(:valid_url) {'https://www.walmart.com/ip/Disney-Minnie-Mouse-Bow-Tique-Headphones/21268095'}
  let(:product_service) {described_class.new(valid_url)}

  it 'creates new product' do
    VCR.use_cassette 'product_valid_url_1' do
      expect(product_service.create_or_update_product).not_to be_nil
    end
  end

  it 'does not create duplicates' do
    VCR.use_cassette 'product_valid_url_1' do
      5.times { product_service.create_or_update_product }
      expect(Product.count).to eq 1
    end
  end

  # todo: add tests for black list
end
