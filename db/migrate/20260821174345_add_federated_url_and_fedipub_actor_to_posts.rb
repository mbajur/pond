class AddFederatedUrlAndFedipubActorToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :federated_url, :string
    add_reference :posts, :fedipub_actor, null: true, foreign_key: { to_table: :fedipub_actors }
  end
end
