class CreateUserTenants < ActiveRecord::Migration[5.0]
  def change
    create_table :user_tenants do |t|

      t.integer :user_id
      t.integer :tenant_id
      t.integer :permission_level
      t.timestamps
    end

    add_index :user_tenants, [:user_id, :tenant_id]
    add_index :user_tenants, :permission_level
  end
end
