class AddSubscribedToNewsLetterToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :subscribed_to_newsletter, :boolean, default: false
  end
end
