class AddCarToRooms < ActiveRecord::Migration[7.1]
  def change
    add_reference :rooms, :car, null: false, foreign_key: true
  end
end
