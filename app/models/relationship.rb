class Relationship < ApplicationRecord
  # userの関連付け
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
