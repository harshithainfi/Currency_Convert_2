class Rate < ApplicationRecord
  validates :rate, :base_currency_id, :currency_id, presence: true
  validates :rate, :numericality => { :greater_than => 0 }
  belongs_to :base_currency, class_name: "Currency"
  belongs_to :currency


  def self.update_rate(response, currency)
    rate = currency.rate
    rate.update(rate: response['rates'][currency.code])
  end

  def self.make_rate_api_call(currency1, currency2)
    response = HTTParty.get("#{ENV["rate_domain"]}?key=#{ENV["api_key"]}")
    update_rate(response, currency1)
    update_rate(response, currency2)
  end

  def self.check_and_update_rate(from_currency,to_currency)
    from_rate_diff = (Time.current - from_currency.rate.updated_at) / 60
    to_rate_diff = (Time.current - to_currency.rate.updated_at) / 60

    if from_rate_diff > 30 || to_rate_diff > 30
      Rate.make_rate_api_call(from_currency, to_currency)
    end
  end
end