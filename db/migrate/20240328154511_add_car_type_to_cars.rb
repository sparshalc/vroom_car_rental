class AddCarTypeToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :car_type, :integer, default: 0
  end
end
