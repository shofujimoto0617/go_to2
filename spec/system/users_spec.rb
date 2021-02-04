require 'rails_helper'

describe 'ユーザー認証のテスト' do
	describe 'ユーザー新規登録' do
		before do
			visit new_user_registration_path
		end
		context '新規登録画面に遷移' do
			it '新規登録に成功する' do
				fill_in 'user[user_name]', with: 'テストユーザー'
				fill_in 'user[email]', with: 'test@example.com'
				fill_in 'user[password]', with: 'password'
				fill_in 'user[password_confirmation]', with: 'password'
				click_button '登録する'

				expect(page).to have_content 'user.signed_up'
			end
			it '新規登録に失敗する' do
				fill_in 'user[user_name]', with: ''
				fill_in 'user[email]', with: ''
				fill_in 'user[password]', with: ''
				fill_in 'user[password_confirmation]', with: ''
				click_button '登録する'

				expect(page).to have_content 'error'
			end
		end
	end

	describe 'ユーザーログイン' do
		let(:user_a) { FactoryBot.create(:user, user_name: 'ユーザーA', email: 'a@expect.com') }
		before do
			visit new_user_session_path
		end
		context 'ログイン画面に遷移' do
			let(:login_user) { user_a }
			it 'ログインに成功する' do
				fill_in 'Email', with: login_user.email
				fill_in 'Password', with: login_user.password
				click_button 'ログイン'

				expect(page).to have_content 'user.signed_in'
			end

			it 'ログインに失敗する' do
				fill_in 'Email', with: ''
				fill_in 'Password', with: ''
				click_button 'ログイン'

				expect(new_user_session_path).to eq('/users/sign_in')
			end
		end
	end

	describe 'ユーザーのテスト' do
		let(:user_a) { FactoryBot.create(:user, user_name: 'ユーザーA', account_name: 'ユーザーA', email: 'a@expect.com', sex: '男性') }
		let(:user_b) { FactoryBot.create(:user, user_name: 'ユーザーB', email: 'b@expect.com') }
		let!(:post_a) { FactoryBot.create(:post, country: '国内', place: '行先', body: 'レビュー', price: '10000', start_date: '2020-01-01', finish_date: '2020-01-10', user: user_a ) }
		before do
			visit new_user_session_path
			fill_in 'Email', with: user_a.email
			fill_in 'Password', with: user_a.password
			click_button 'ログイン'
		end
		describe '自分の詳細画面のテスト' do
			context '表示の確認' do
				it 'My pageと表示される' do
					expect(page).to have_content('My page')
				end
				it '投稿一覧の削除ボタンが表示される' do
					expect(page).to have_link '', href: post_path(post_a)
				end
			end
		end

		describe '他人の詳細画面のテスト' do
			before do
				visit user_path(user_b)
			end
			context '表示の確認' do
				it '編集ボタンが表示されない' do
					expect(page).to have_no_content('プロフィール変更')
				end
				it 'Telは表示されない' do
					expect(page).to have_no_content('Tel')
				end
				it 'Genderは表示されない' do
					expect(page).to have_no_content('Gender')
				end
				it 'Mail addressは表示されない' do
					expect(page).to have_no_content('Mail address')
				end
				it '投稿一覧の削除ボタンが表示されない' do
					expect(page).to have_no_link '', href: post_path(post_a)
				end
			end
		end

		describe '共通詳細画面テスト' do
			before do
				visit user_path(user_a)
			end
			context '表示の確認' do
				it '投稿一覧のplaceのリンクが正しい' do
					expect(page).to have_link post_a.place, href: post_path(post_a)
				end
				it '投稿一覧にcountry画像が表示される' do
					expect(page).to have_selector("img[src$='/assets/japan-2784cd1d8209cd227f705a9636c373f20e660ff93e7968a0f881f672d9f839f3.png']")
				end
				it '投稿一覧にbodyが表示される' do
					expect(page).to have_content (post_a.body)
				end
				it '投稿一覧にpriceが表示される' do
					expect(page).to have_content (post_a.price.to_s(:delimited))
				end
				it '投稿一覧のstart_dateが表示される' do
					expect(page).to have_content (post_a.start_date.strftime('%Y/%m/%d'))
				end
				it '投稿一覧のfinish_dateが表示される' do
					expect(page).to have_content (post_a.finish_date.strftime('%Y/%m/%d'))
				end
				it '投稿一覧の日時が表示される' do
					expect(page).to have_content (post_a.created_at.strftime('%Y/%m/%d %H:%M'))
				end
				it '投稿一覧のコメントのリンクが正しい' do
					expect(page).to have_link '', href: new_post_post_comment_path(post_a)
				end
				it '投稿一覧のいいねのリンクが正しい' do
					expect(page).to have_link '', href: post_favorites_path(post_a)
				end
			end
		end

		describe '編集のテスト' do
			context '自分の編集画面への遷移' do
				it '遷移できる' do
					visit edit_user_path(user_a)
					expect(current_path).to eq('/users/' + user_a.id.to_s + '/edit')
				end
			end
			context '他人の編集画面への遷移' do
				it '遷移できない' do
					visit edit_user_path(user_b)
					expect(current_path).to eq('/users/' + user_a.id.to_s)
				end
			end
			context '表示の確認' do
				before do
					visit edit_user_path(user_a)
				end
				it 'Change registration informationと表示される' do
					expect(page).to have_content('Change registration information')
				end
				it '画像編集フォームが表示される' do
					expect(page).to have_field 'user[image]'
				end
				it '名前編集フォームに名前が表示される' do
					expect(page).to have_field 'user[user_name]'
				end
				it 'ユーザーネーム編集フォームにユーザーネームが表示される' do
					expect(page).to have_field 'user[account_name]'
				end
				it 'ウェブサイト編集フォームにウェブサイトが表示される' do
					expect(page).to have_field 'user[website]'
				end
				it '自己紹介編集フォームに自己紹介が表示される' do
					expect(page).to have_field 'user[introduction]'
				end
				it '電話番号編集フォームに電話番号が表示される' do
					expect(page).to have_field 'user[phone_number]'
				end
				it '電話番号編集フォームに電話番号が表示される' do
					expect(page).to have_checked_field 'user[sex]'
				end
				it '完了ボタンが表示される' do
					expect(page).to have_button '完了'
				end
			end
		end
	end

end