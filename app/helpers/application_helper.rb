module ApplicationHelper
  require 'uri'

  def price(cents)
    return '' unless cents.is_a?(Integer) || (cents > 0)
    "#{Product.currency}#{cents/100}"
  end

  def valid_url?(uri)
    uri = URI.parse(uri)
  rescue URI::InvalidURIError
    false
  end
end
