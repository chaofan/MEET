class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.boolean :public

      t.integer :item_id
      t.string  :item_type

      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
