class AddSlugToQuotum < ActiveRecord::Migration

  # support add_column with null: false
  def up
    # same max-length as name
    add_column :quota, :slug, :string, limit: 128

    Quotum.all.each do |quotum|
      quotum.slug = quotum.name.parameterize
      quotum.save!
    end

    change_column_null :quota, :slug, false
    add_index :quota, :slug, unique: true
  end

  def down
    remove_column :quota, :slug
  end
end
