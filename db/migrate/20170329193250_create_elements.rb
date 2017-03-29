class CreateElements < ActiveRecord::Migration[5.0]
  def change
    create_table :elements do |t|
      t.references :link, foreign_key: true
      t.string :tag
      t.text :content

      t.timestamps
    end
  end
end
