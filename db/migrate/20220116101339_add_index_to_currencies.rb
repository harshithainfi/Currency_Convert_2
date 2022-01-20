class AddIndexToCurrencies < ActiveRecord::Migration[6.1]
  def change
   add_index :currencies, :code,  unique: true
  end
end

