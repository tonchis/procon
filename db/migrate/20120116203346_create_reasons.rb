class CreateReasons < ActiveRecord::Migration
  def up
    create_table :reasons do |t|
      t.string  :text,    null: false
      t.integer :dilemma_id, null: false
      t.string  :type
    end
  end

  def down
    drop_table :reasons
  end
end
