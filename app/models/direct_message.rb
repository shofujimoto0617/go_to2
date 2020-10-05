class DirectMessage < ApplicationRecord
  # userの関連付け
  belongs_to :user
  # roomの関連付け
  belongs_to :room

  # バリデーション
  validates :message, presence: true
end
