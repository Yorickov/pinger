class AddUserReferenceToSites < ActiveRecord::Migration[6.1]
  def change
    add_reference :sites, :user, foreign_key: true
  end
end
