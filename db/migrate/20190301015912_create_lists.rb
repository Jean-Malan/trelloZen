class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :name
      t.boolean :closed
      t.string :idnboard
      t.float :pos
      t.boolean :subscribed
      t.integer :softlimit

      t.timestamps
    end
  end
end
