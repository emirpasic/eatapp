class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|

      t.column :restaurant_id, :integer, null: false
      t.column :user_id, :integer, null: false

      t.column :status, :integer, null: false
      t.column :start_time, :datetime, null: false

      # not sure if I understand this property, I assume it is the number of guests?
      t.column :covers, :integer, null: false

      t.column :notes, :string

      t.timestamps
    end
  end
end
