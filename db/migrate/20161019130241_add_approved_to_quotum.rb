class AddApprovedToQuotum < ActiveRecord::Migration
  def up
    add_column :quota, :approved, :boolean, default: true, null: false

    Quotum.update_all(approved: true)

    add_index :quota, :approved
  end

  def down
    remove_column :quota, :approved
  end
end
