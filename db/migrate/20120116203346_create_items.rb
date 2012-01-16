class CreateItems < ActiveRecord::Migration
  def up
    create_table :items do |t|
      t.string  :text,    null: false
      t.integer :list_id, null: false
      t.string  :type
    end
  end

  def down
    drop_table :items
  end
end
