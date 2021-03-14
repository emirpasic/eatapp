class CreateRestaurants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurants do |t|

      # This limits only one restaurant user to manage the restaurant
      # TODO extract to many(restaurant)-to-many(user) table to support multiple restaurant users for a single restaurant, right now only one manager allowed
      t.column :restaurant_user_id, :integer, null: false

      t.string :name
      t.string :cuisines
      t.string :phone
      t.string :email
      t.string :location
      t.string :opening_hours

      t.timestamps
    end
  end
end
