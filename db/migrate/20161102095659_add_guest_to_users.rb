class AddGuestToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :guest, :boolean, default: false, null: false

    User.update_all(guest: false)

    add_index :users, :guest
  end

  def down
    remove_column :users, :guest
  end
end
