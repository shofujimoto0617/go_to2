class TagMap < ApplicationRecord
  # postの関連付け
  belongs_to :post
  # tagの関連付け
  belongs_to :tag
end
