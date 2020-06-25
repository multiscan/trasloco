class CreateBoxes < ActiveRecord::Migration[6.0]
  def change
    create_table :boxes do |t|
		t.integer :user_id
		t.integer :room_id
		t.integer :label
		t.text    :description
		t.boolean :fragile

		t.timestamps    	
    end
  end
end
