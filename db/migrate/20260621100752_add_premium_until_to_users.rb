class AddPremiumUntilToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :premium_until, :datetime
  end
end
