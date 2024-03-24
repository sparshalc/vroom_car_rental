class AddNameToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :name, :string
  end
end
