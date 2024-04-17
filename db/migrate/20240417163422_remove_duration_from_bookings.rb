class RemoveDurationFromBookings < ActiveRecord::Migration[7.1]
  def change
    remove_column :bookings, :duration
  end
end
