require 'rails_helper'

describe 'post機能', type: :system do
	describe '一覧機能' do
		let(:user_a) { FactoryBot.create(:user, user_name: 'ユーザーA', email: 'a@expect.com') }
		let(:user_b) { FactoryBot.create(:user, user_name: 'ユーザーB', email: 'b@expect.com') }

	    before do
	    	FactoryBot.create(:post, country: 1, place: '旅行先', user: user_a)
	    	visit new_user_session_path
			fill_in 'Email', with: login_user.email
			fill_in 'Password', with: login_user.password
			click_button 'ログイン'
	    end

		context 'ユーザーAがログインしているとき' do
			let(:login_user) { user_a }

			it 'ユーザーAが作成したpostが表示される' do
				expect(page).to have_content '旅行先'
			end
		end

		context 'ユーザーBがログインしているとき' do
			let(:login_user) { user_b }

			it 'ユーザーAが作成したpostが表示されない' do
				expect(page).to have_no_content '旅行先'
			end
		end
	end
end

