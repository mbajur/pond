class AddUsernameToCollections < ActiveRecord::Migration[8.1]
  def change
    add_column :collections, :username, :string
    add_index :collections, :username
  end
end
