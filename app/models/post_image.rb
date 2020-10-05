class PostImage < ApplicationRecord
  # postの関連付け
  belongs_to :post
  # refile用attachment
  attachment :image

end
