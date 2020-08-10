FactoryBot.define do
	url_array = [
		"http://www.google.com",
		"http://www.goldbelly.com",
		"http://www.github.com",
		"http://www.goodreads.com"
	]

	factory :random_url, class: Url do
		long_url { url_array.sample }
		slug { ('a'...'z').to_a.shuffle[0,8].join }
	end
end