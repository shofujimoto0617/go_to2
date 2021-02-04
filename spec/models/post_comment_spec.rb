require 'rails_helper'

RSpec.describe 'PostCommentモデルのテスト', type: :model do
	describe 'アソシエーションのテスト' do
		context 'Userモデルとの関係' do
			it 'N:1となってる' do
				expect(PostComment.reflect_on_association(:user).macro).to eq :belongs_to
			end
		end
		context 'Postモデルとの関係' do
			it 'N:1となってる' do
				expect(PostComment.reflect_on_association(:post).macro).to eq :belongs_to
			end
		end
	end
end