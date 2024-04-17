class AddMoneyToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :base_fare, :integer, default: 0
    add_column :payments, :service_fee, :integer, default: 0
    add_column :payments, :total_amount, :integer, default: 0
  end
end
