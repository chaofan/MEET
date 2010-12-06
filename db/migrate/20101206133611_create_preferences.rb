class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.string  :name
      t.string  :value
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
