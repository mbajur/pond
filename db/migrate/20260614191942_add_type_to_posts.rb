class AddTypeToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :type, :string, null: false, default: "Post::Url"
  end
end
