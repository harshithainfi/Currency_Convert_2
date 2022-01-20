class Rate < ApplicationRecord

  validates :rate, :base_currency_id, :currency_id, presence: true
  validates :rate, :numericality => { :greater_than => 0}
  belongs_to :base_currency, class_name: "Currency"
  belongs_to :currency

end