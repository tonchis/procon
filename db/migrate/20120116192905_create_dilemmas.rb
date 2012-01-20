class CreateDilemmas < ActiveRecord::Migration
  def up
    create_table :dilemmas do |t|
      t.string  :name,    null: false
      t.integer :user_id, null: false
    end
  end

  def down
    drop_table :dilemmas
  end
end
