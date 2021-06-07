class AddColumnsToSites < ActiveRecord::Migration[6.1]
  def change
    add_column :sites, :enabled, :boolean, default: true
    add_column :sites, :status, :string, default: 'inactive'
    add_column :sites, :last_pinged_at, :integer
  end
end
