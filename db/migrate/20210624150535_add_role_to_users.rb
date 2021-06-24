class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    create_enum :user_role, %w[user admin]

    add_column :users, :role, :user_role, default: 'user'
  end
end
