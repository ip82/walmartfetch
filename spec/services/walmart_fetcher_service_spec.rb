require 'rails_helper'

describe Walmart::WalmartFetcherService do
  let(:valid_url) {'https://www.walmart.com/ip/Disney-Minnie-Mouse-Bow-Tique-Headphones/21268095'}
  let(:valid_url_with_other_params) {'https://www.walmart.com/ip/Disney-Minnie-Mouse-Bow-Tique-Headphones/21268095?adv=track'}
  let(:valid_non_walmart_url) {'https://google.com'}
  let(:invalid_url) {'just some text'}

  let(:fetcher_service_valid_1) {described_class.new(valid_url)}
  let(:fetcher_service_valid_2) {described_class.new(valid_url_with_other_params)}
  let(:fetcher_service_invalid_1) {described_class.new(valid_non_walmart_url)}
  let(:fetcher_service_invalid_2) {described_class.new(invalid_url)}

  it 'should return product data for valid url 1' do
    VCR.use_cassette 'product_valid_url_1' do
      expect(fetcher_service_valid_1.get_product_data[:walmart_id]).to be_present
    end
  end

  it 'should return product data for valid url 2' do
    VCR.use_cassette 'product_valid_url_2' do
      expect(fetcher_service_valid_2.get_product_data[:walmart_id]).to be_present
    end
  end

  it 'handles exceptions for invalid urls' do
    expect { fetcher_service_invalid_1.get_product_data }.to raise_error Walmart::WalmartFetcherService::WalmartFetcherError
    expect { fetcher_service_invalid_2.get_product_data }.to raise_error Walmart::WalmartFetcherService::WalmartFetcherError
  end
end
