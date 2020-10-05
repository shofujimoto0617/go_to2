class Entry < ApplicationRecord
  # userの関連付け
  belongs_to :user
  # roomの関連付け
  belongs_to :room
end
