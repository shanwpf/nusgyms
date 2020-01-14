class CreateOccupancies < ActiveRecord::Migration[6.0]
  def change
    create_table :occupancies do |t|
      t.timestamp :time
      t.integer :utown
      t.integer :mpsh
      t.integer :usc

      t.timestamps
    end
  end
end
