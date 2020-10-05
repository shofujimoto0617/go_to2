class Tag < ApplicationRecord
  # tag_mapの関連付け
  has_many :tag_maps, dependent: :destroy, foreign_key: 'tag_id'
  # postの関連付け
  has_many :posts, through: :tag_maps

  # 入力されたタグ名を部分一致で探す
  def self.search(search)
  	if search
  	  @tags = Tag.where("tag_name LIKE?","%#{search}%")
  	end
  end
end
