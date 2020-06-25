class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
		t.integer :user_id
		t.integer :floor
		t.string :name
		t.string :label
		t.timestamps
    end
  end
end
