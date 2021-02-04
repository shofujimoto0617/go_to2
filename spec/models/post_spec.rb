require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
	describe 'バリデーションのテスト' do
		let(:user) { FactoryBot.create(:user, user_name: 'ユーザーA', email: 'a@expect.com') }
	    let!(:post) { FactoryBot.build(:post, user_id: user.id) }

	    context 'countryカラム' do
		    it '空欄でないこと' do
		      post.country = ''
		      expect(post.valid?).to eq false;
		    end
	    end
	    context 'placeカラム' do
		    it '空欄でないこと' do
		      post.place = ''
		      expect(post.valid?).to eq false;
		    end
		    it '20文字以下であること' do
		    	post.place = Faker::Lorem.characters(number:21)
		    	expect(post.valid?).to eq false;
		    end
	    end
	    context 'bodyカラム' do
	    	it '200文字以下であること' do
	    		post.body = Faker::Lorem.characters(number:201)
	    		expect(post.valid?).to eq false;
	    	end
	    end
	    context 'start and finishカラム' do
	    	it '日付が正しく入力される' do
	    		post.start_date = '2020-02-01'
	    		post.finish_date = '2020-01-01'
	    		expect(post.valid?).to eq false;
	    	end
	    end
    end

    describe 'アソシエーションのテスト' do
    	context 'Userモデルとの関係' do
    		it 'N:1となっている' do
    			expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
    		end
    	end
    	context 'post_imageモデルとの関係' do
    		it '1:Nとなっている' do
    			expect(Post.reflect_on_association(:post_images).macro).to eq :has_many
    		end
    	end
    	context 'post_commentモデルとの関係' do
    		it '1:Nとなっている' do
    			expect(Post.reflect_on_association(:post_comments).macro).to eq :has_many
    		end
    	end
    	context 'favoritesモデルとの関係' do
    		it '1:Nとなっている' do
    			expect(Post.reflect_on_association(:favorites).macro).to eq :has_many
    		end
    	end
    	context 'tag_mapモデルとの関係' do
    		it '1:Nとなっている' do
    			expect(Post.reflect_on_association(:tag_maps).macro).to eq :has_many
    		end
    	end
    	context 'tagモデルとの関係' do
    		it '1:Nとなっている' do
    			expect(Post.reflect_on_association(:tags).macro).to eq :has_many
    		end
    	end
    end
end