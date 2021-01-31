FactoryBot.define do
	factory :user do
		user_name { 'テストユーザー' }
		email { 'test1@example.com' }
		password { 'password' }
	end
end