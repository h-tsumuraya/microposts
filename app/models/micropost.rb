class Micropost < ActiveRecord::Base
  belongs_to :user

  has_many  :user_favs, class_name:  "Favorite",
                        foreign_key: "micropost_id",
                        dependent:   :destroy
  has_many  :favorited_users, through: :user_favs, source: :user

  # Retweet
  has_many :retweets, class_name:  "Retweet",
                      foreign_key: "micropost_id",
                      dependent: :destroy
  has_many :retweet_users, through: :retweets, source: :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
