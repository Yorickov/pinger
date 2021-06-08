class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs do |t|
      t.references :site, null: false, foreign_key: true
      t.string :status, null: false
      t.integer :code
      t.integer :response_time

      t.timestamps
    end
  end
end
