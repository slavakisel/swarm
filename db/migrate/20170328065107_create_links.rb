class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.text :url, limit: 2083
      t.datetime :last_modified_at
      t.datetime :last_processed_at

      t.timestamps
    end
  end
end
