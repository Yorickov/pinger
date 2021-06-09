class AddProtocolAndIntervalToSites < ActiveRecord::Migration[6.1]
  def change
    add_column :sites, :protocol, :string, null: false
    add_column :sites, :interval, :integer, null: false
  end
end
