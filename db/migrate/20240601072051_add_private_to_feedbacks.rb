class AddPrivateToFeedbacks < ActiveRecord::Migration[7.1]
  def change
    add_column :feedbacks, :private, :boolean, default: true
  end
end
