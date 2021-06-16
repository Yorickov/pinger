class AddTimeoutAndCheckingStringToSites < ActiveRecord::Migration[6.1]
  def change
    add_column :sites, :timeout, :integer, default: 10
    add_column :sites, :checking_string, :string
  end
end
