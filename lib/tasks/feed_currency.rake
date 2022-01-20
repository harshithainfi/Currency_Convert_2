task feed_currency: :environment do
	response = HTTParty.get("#{ENV["currency_domain"]}?key=#{ENV["api_key"]}")
	data = response['currencies']
	data.each do |code, name|
		Currency.create({code: code, name: name})
	end
end