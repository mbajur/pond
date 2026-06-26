class AddDescriptionToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :description, :text
  end
end
