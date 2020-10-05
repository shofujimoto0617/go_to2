class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # bookの関連付け
  has_many :posts, dependent: :destroy
  # post_commentの関連付け
  has_many :post_comments, dependent: :destroy
  # favoriteの関連付け
  has_many :favorites, dependent: :destroy
  # relationshipの関連付け
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォロー取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォロワー取得
  has_many :following_user, through: :follower, source: :followed # 自分がフォーローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人
  # messageの関連付け
  has_many :direct_message, dependent: :destroy
  # entryの関連付け
  has_many :entries, dependent: :destroy

  # refileのattachment
  attachment :image, destroy: false

  # バリデーション/エラーにする条件
  validates :user_name, presence: true, length: {maximum: 10, minimum: 2}
  validates :account_name, length: {maximum: 20}
  validates :introduction, length: {maximum: 50}

  # sexカラムの選択内容
  enum sex:{
    男性: 0, 女性: 1
  }

  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしている場合 trueで返す
  def following?(user)
    following_user.include?(user)
  end
end
