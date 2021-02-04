require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
	describe 'バリデーションのテスト' do
		let(:user) { FactoryBot.build(:user) }
		subject { test_user.valid? }
		context 'user_nameカラム' do
			let(:test_user) { user }
			it '空欄でないこと' do
				test_user.user_name = ''
				is_expected.to eq false;
			end
			it '2文字以上であること' do
				test_user.user_name = Faker::Lorem.characters(number:1)
				is_expected.to eq false;
			end
			it '20文字以下であること' do
				test_user.user_name = Faker::Lorem.characters(number:11)
				is_expected.to eq false;
			end
		end

		context 'account_nameカラム' do
			let(:test_user) { FactoryBot.build(:user) }
			it '20文字以下であること' do
				test_user.account_name = Faker::Lorem.characters(number:21)
				is_expected.to eq false
			end
		end

		context 'introductionカラム' do
			let(:test_user) { FactoryBot.build(:user) }
			it '50文字以下であること' do
				test_user.introduction = Faker::Lorem.characters(number:51)
			end
		end
	end

	describe 'アソシエーションのテスト' do
		context 'Postモデルとの関係' do
			it '1:Nとなっている' do
				expect(User.reflect_on_association(:posts).macro).to eq :has_many
			end
		end

		context 'PostCommentモデルとの関係' do
			it '1:Nとなっている' do
				expect(User.reflect_on_association(:post_comments).macro).to eq :has_many
			end
		end

		context 'Favoriteモデルとの関係' do
			it '1:Nとなっている' do
				expect(User.reflect_on_association(:favorites).macro).to eq :has_many
			end
		end

		context 'Favoriteモデルとの関係' do
			it '1:Nとなっている' do
				expect(User.reflect_on_association(:favorites).macro).to eq :has_many
			end
		end

		context 'Relationship(follower)モデルとの関係' do
			it '1:Nとなっている' do
				expect(User.reflect_on_association(:follower).macro).to eq :has_many
			end
		end

		context 'Relationship(followed)モデルとの関係' do
			it '1:Nとなっている' do
				expect(User.reflect_on_association(:followed).macro).to eq :has_many
			end
		end

		context 'DirectMessageモデルとの関係' do
			it '1:Nとなっている' do
				expect(User.reflect_on_association(:direct_message).macro).to eq :has_many
			end
		end

		context 'Entryモデルとの関係' do
			it '1:Nとなっている' do
				expect(User.reflect_on_association(:entries).macro).to eq :has_many
			end
		end
	end
end