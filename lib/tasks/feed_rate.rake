task feed_rate: :environment do
	Currency.create_or_update_rates
end

