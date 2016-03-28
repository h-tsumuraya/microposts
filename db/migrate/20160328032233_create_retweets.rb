class CreateRetweets < ActiveRecord::Migration
  def change
    create_table :retweets do |t|
      t.integer :user_id
      t.integer :micropost_id

      t.timestamps null: false
      t.index [:user_id, :micropost_id], unique: true
    end
  end
end
