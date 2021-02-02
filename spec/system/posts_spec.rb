require 'rails_helper'

describe 'post機能', type: :system do
	describe '一覧機能' do
		let(:user_a) { FactoryBot.create(:user, user_name: 'ユーザーA', email: 'a@expect.com') }
		let(:user_b) { FactoryBot.create(:user, user_name: 'ユーザーB', email: 'b@expect.com') }
		let!(:post_a) { FactoryBot.create(:post, country: '国内', place: '行先', body: 'レビュー', price: '10000', start_date: '2020-01-01', finish_date: '2020-01-10', user: user_a ) }
		let!(:post_b) { FactoryBot.create(:post, place: '行先', user: user_b ) }
		let!(:post_b) { FactoryBot.create(:post, country: '海外', place: '行先', body: 'レビュー', price: '10000', start_date: '2020-02-01', finish_date: '2020-02-10', user: user_b ) }


	    before do
	    	visit new_user_session_path
			fill_in 'Email', with: login_user.email
			fill_in 'Password', with: login_user.password
			click_button 'ログイン'
	    end

	    shared_examples_for 'ユーザーAが作成したpostが表示される' do
	    	it { expect(page).to have_content '行先' }
	    	it { expect(page).to have_selector("img[src$='/assets/japan-2784cd1d8209cd227f705a9636c373f20e660ff93e7968a0f881f672d9f839f3.png']") }
			it { expect(page).to have_content '行先' }
			it { expect(page).to have_content 'レビュー' }
	    end

	    describe '一覧表示機能' do
			context 'ユーザーAがログインしているとき' do
				let(:login_user) { user_a }

				before do
					visit posts_path
				end

				it_behaves_like 'ユーザーAが作成したpostが表示される'
			end

			context 'ユーザーBがログインしているとき' do
				let(:login_user) { user_b }

				before do
					visit posts_path
				end

				it_behaves_like 'ユーザーAが作成したpostが表示される'
			end
		end

		describe '詳細画面機能' do
			context '自分の詳細画面へ遷移' do
				let(:login_user) { user_a }

				before do
					visit post_path(post_a)
				end

				it_behaves_like 'ユーザーAが作成したpostが表示される'
				it 'コメントリンクが表示される' do
		   	    	expect(page).to have_link href: new_post_post_comment_path(post_a)
		   	    end
		   	    it 'いいねが表示される' do
		   	    	expect(page).to have_link href: post_favorites_path(post_a)
		   	    end
		   	    it '編集リンクが表示される' do
		   	    	expect(page).to have_link href: edit_post_path(post_a)
		   	    end
		   	    it '削除リンクが表示される' do
		   	    	expect(page).to have_link href: post_path(post_a)
		   	    end


			end

			context '他人の詳細画面へ遷移' do
				let(:login_user) { user_a }

				before do
					visit post_path(post_b)
				end

		   	    it '編集リンクが表示されない' do
		   	    	expect(page).to have_no_link href: edit_post_path(post_b)
		   	    end

			end
		end

		describe '新規投稿機能' do
			context '表示の確認' do
				let(:login_user) { user_a }

				before do
					visit new_post_path
				end

				it 'Take write memoriesと表示される' do
			        expect(page).to have_content 'Take write memories'
				end
				it 'countryフォームが表示される' do
				  	expect(page).to have_field 'post[country]'
				end
			    it 'placeフォームが表示される' do
				  	expect(page).to have_field 'post[place]'
		   	    end
		   	    it 'bodyフォームが表示される' do
				  	expect(page).to have_field 'post[body]'
		   	    end
		   	    it 'priceフォームが表示される' do
				  	expect(page).to have_field 'post[price]'
		   	    end
		   	    it 'start_dateフォームが表示される' do
				  	expect(page).to have_field 'post[start_date]'
		   	    end
		   	    it 'finish_dateフォームが表示される' do
				  	expect(page).to have_field 'post[finish_date]'
		   	    end
				it '完了ボタンが表示される' do
				  	expect(page).to have_button '完了'
			    end

				it '投稿に成功する' do
					fill_in 'post[place]', with: Faker::Lorem.characters(number:5)
					select '国内', from: '国内or海外'
					click_button '完了'
					expect(page).to have_content '* A record of your trip has been posted'
				end

				it '投稿に失敗する' do
					click_button '完了'
					expect(page).to have_content 'error'
					expect(current_path).to eq('/posts')
				end
			end
		end

		describe '編集のテスト' do
			context '自分の投稿の編集画面への遷移' do
				let(:login_user) { user_a }

				before do
					visit edit_post_path(post_a)
				end
				it '遷移できる' do
					expect(current_path).to eq('/posts/' + post_a.id.to_s + '/edit')
				end
			end

			context '他人の投稿の編集画面への遷移' do
				let(:login_user) { user_a }

				before do
					visit edit_post_path(post_b)
				end
				it '遷移できない' do
					expect(current_path).to eq('/posts')
				end
			end

			context '表示の確認' do
				let(:login_user) { user_a }

				before do
					visit edit_post_path(post_a)
				end

				it 'To editと表示される' do
					expect(page).to have_content('To edit')
				end
				it 'countryフォームが表示される' do
				  	expect(page).to have_field 'post[country]', with: post_a.country
				end
			    it 'placeフォームが表示される' do
				  	expect(page).to have_field 'post[place]', with: post_a.place
		   	    end
		   	    it 'bodyフォームが表示される' do
				  	expect(page).to have_field 'post[body]', with: post_a.body
		   	    end
		   	    it 'priceフォームが表示される' do
				  	expect(page).to have_field 'post[price]', with: post_a.price
		   	    end
		   	    it 'start_dateフォームが表示される' do
				  	expect(page).to have_field 'post[start_date]', with: post_a.start_date
		   	    end
		   	    it 'finish_dateフォームが表示される' do
				  	expect(page).to have_field 'post[finish_date]', with: post_a.finish_date
		   	    end
		   	    it '編集するボタンが表示される' do
		   	    	expect(page). to have_button '編集する'
		   	    end
			end

			context 'フォームの確認' do
				let(:login_user) { user_a }

				before do
					visit edit_post_path(post_a)
				end

				it '編集に成功する' do
					click_button '編集する'
					expect(page).to have_content 'Edited the travel record'
					expect(current_path).to eq '/posts/' + post_a.id.to_s
				end
				it '編集に失敗する' do
					fill_in 'post[place]', with: ''
					click_button '編集する'
					expect(page).to have_content 'error'
					expect(edit_post_path(post_a)).to eq '/posts/' + post_a.id.to_s + '/edit'
				end
			end
		end
	end
end

