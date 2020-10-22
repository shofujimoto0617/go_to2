# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 簡単ログイン用 データ
User.create(user_name: 'ゲストユーザー', email: 'test@example.com', password: 'testtest', account_name: 'guest_user', introduction: 'ゲストユーザーのため、編集はできません。', website: 'https://www.instagram.com/?hl=ja', phone_number: '090-5516-3323')
