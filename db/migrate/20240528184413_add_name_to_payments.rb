class AddNameToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :name, :string
  end
end
