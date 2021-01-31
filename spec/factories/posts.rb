FactoryBot.define do
	factory :post do
		country { 1 }
		place { 'アメリカ' }
		body { 'RSpec&Capybara&FactoryBotを準備する' }
		price { 1000 }
		user
	end
end
