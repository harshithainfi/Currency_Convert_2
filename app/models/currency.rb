class Currency < ApplicationRecord
  validates :name, :code, uniqueness: true
  validates :name, :code, presence: true
  validates_length_of :code, {minimum: 3, maximum: 4}
  has_one :rate

  def self.convert(from_currency,to_currency,value)
    Rails.cache.fetch("currency_rates", expires_in: 30.minutes) do
      Currency.create_or_update_rates
      "update the rate after every 30 mins"
    end
    from_curr = Currency.find_by(code: from_currency)
    to_curr = Currency.find_by(code: to_currency)
    result = value.to_f * (to_curr.rate.rate) / (from_curr.rate.rate)
  end

  def self.create_or_update_rates
    response = HTTParty.get("#{ENV["rate_domain"]}?key=#{ENV["api_key"]}")
    base_currency = Currency.find_by_code('USD')
    if base_currency.nil?
      puts "base_currency is not present"
    else
      data = response['rates']
      data.each do |currency_code,rate|
        currency = Currency.find_by_code(currency_code)
        db_rate = Rate.find_by({base_currency_id: base_currency.id, currency_id: currency.id})
        if db_rate.present?
          db_rate.rate = rate
          db_rate.save
        else
          Rate.create({base_currency_id: base_currency.id, currency_id: currency.id, rate: rate})
        end
      end
    end
  end

end