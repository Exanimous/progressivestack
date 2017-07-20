class AddTenantToQuotum < ActiveRecord::Migration[5.0]
  def change
    add_column :quota, :tenant_id, :integer
    add_index :quota, :tenant_id
  end
end
