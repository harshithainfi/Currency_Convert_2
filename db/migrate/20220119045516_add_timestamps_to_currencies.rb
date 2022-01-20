class AddTimestampsToCurrencies < ActiveRecord::Migration[6.1]
  def change
   add_column :currencies, :created_at, :datetime
   add_column :currencies, :updated_at, :datetime
  end
end
