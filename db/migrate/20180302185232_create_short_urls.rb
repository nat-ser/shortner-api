class CreateShortUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :short_urls do |t|
      t.string :short_address, null: false

      t.timestamps
    end
  end
end
