class Currency < ApplicationRecord
  validates :name, :code, uniqueness: true
  validates :name, :code, presence: true
  validates_length_of :code, {minimum: 3, maximum: 4}
  has_one :rate


  def self.convert(from_currency,to_currency,value)
    from_curr = Currency.find_by(code: from_currency)
    to_curr = Currency.find_by(code: to_currency)
    Rate.check_and_update_rate(from_curr, to_curr)
    result = value.to_f * (to_curr.rate.rate) / (from_curr.rate.rate)
  end
end

