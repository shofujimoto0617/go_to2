class PostComment < ApplicationRecord
  # userの関連付け
  belongs_to :user
  # postの関連付け
  belongs_to :post
end
