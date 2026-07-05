class AddContentToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :content, :text
  end
end
