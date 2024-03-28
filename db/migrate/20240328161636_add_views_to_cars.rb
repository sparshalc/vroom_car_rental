class AddViewsToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :views, :integer, default: 0
  end
end
