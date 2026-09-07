# frozen_string_literal: true

class MovePostsToFedipubActors < ActiveRecord::Migration[8.1]
  def up
    Post.find_each do |post|
      user = User.find(post.user_id)
      post.update! fedipub_actor: user.fedipub_actor
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
