class User < ActiveRecord::Base
    before_save { self.email = self.email.downcase }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    validates :profile, length: {maximum: 1000}
    has_secure_password

    has_many :microposts #投稿

    # フォロー一覧
    has_many :following_relationships, class_name:  "Relationship",
                                       foreign_key: "follower_id",
                                       dependent:   :destroy #ユーザーが削除されれば、これも削除される
    has_many :following_users, through: :following_relationships, source: :followed

    # フォロワー一覧
    has_many :follower_relationships,  class_name:  "Relationship",
                                       foreign_key: "followed_id",
                                       dependent:   :destroy
    has_many :follower_users, through: :follower_relationships, source: :follower

    ## お気に入り一覧関連
    # お気に入りの関係テーブルを取得
    has_many :micropost_favs, class_name:  "Favorite",
                          foreign_key: "user_id", #ここにユーザーのidが入る
                          dependent:   :destroy
    # microposts_favを元に、micropostを取得
    has_many :favorite_microposts, through: :micropost_favs, source: :micropost


    # 他のユーザーをフォローする
    def follow(other_user)
      following_relationships.find_or_create_by(followed_id: other_user.id)
    end

    # フォローしているユーザーをアンフォローする
    def unfollow(other_user)
      following_relationship = following_relationships.find_by(followed_id: other_user.id)
      following_relationship.destroy if following_relationship
    end

    # あるユーザーをフォローしているかどうか？
    def following?(other_user)
      following_users.include?(other_user)
    end

    def feed_items
      # フォローしているユーザーのIDを配列で取得。それに自分のIDを追加する的な処理
      Micropost.where(user_id: following_user_ids + [self.id])
    end

    # お気に入りに追加
    def add_to_fav(micropost)
      micropost_favs.find_or_create_by(micropost_id: micropost.id)
    end

    # お気に入りの投稿をすべて取得
    def get_all_fav
      favorite_microposts.all
    end

    # 投稿をお気に入りから削除
    def del_from_fav(micropost)
      fav = micropost_favs.find_by(micropost_id: micropost.id)
      fav.destroy if fav
    end
end
