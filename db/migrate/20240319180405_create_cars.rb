class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.string :brand
      t.string :model
      t.string :color
      t.integer :mileage
      t.boolean :availability
      t.string :location
      t.decimal :rental_price
      t.boolean :insurance
      t.string :image
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
