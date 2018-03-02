class CreateUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :urls do |t|
      t.references :short_url, foreign_key: true
      t.string :full_address, null: false
      t.string :device_type, null: false
      t.integer :redirect_count, default: 0

      t.timestamps
    end
  end
end
