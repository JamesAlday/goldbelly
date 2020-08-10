class CreateUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :urls do |t|
      t.string :long_url
      t.string :slug
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
