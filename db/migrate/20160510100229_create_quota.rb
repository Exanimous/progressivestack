class CreateQuota < ActiveRecord::Migration
  def change
    create_table :quota do |t|

      t.string :name, null: false, limit: 128
      t.timestamps null: false
    end
    add_index :quota, :name, unique: true
  end
end
