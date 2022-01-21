task feed_rate: :environment do
	response = HTTParty.get("#{ENV["rate_domain"]}?key=#{ENV["api_key"]}")
	base_currency = Currency.find_by_code('USD')
	if base_currency.nil?
		puts "base_currency is not present"
	else
		data = response['rates']
		data.each do |currency_code,rate|
			currency = Currency.find_by_code(currency_code)
			db_rate = Rate.find_by({base_currency_id: base_currency.id, currency_id: currency.id})
			if db_rate.present?
				db_rate.rate = rate
				db_rate.save
			else
				Rate.create({base_currency_id: base_currency.id, currency_id: currency.id, rate: rate})
			end
		end
	end
end

