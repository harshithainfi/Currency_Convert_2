class CurrenciesController < ApplicationController
	def index
		currency = Currency.all.limit(10)
		render json: { status: 'SUCCESS', message: 'Loaded currency', data: currency }
	end

	def show
		currency = Currency.find_by_code(params[:id])
		if currency.present?
			render :json => currency.to_json
		else
			render json: { status: 'FAILED', message: 'Not Found', data: currency }
		end
	end

	def convert
		result = Currency.convert(params[:from_currency],params[:to_currency],params[:value])
		render json: { status: 'SUCCESS', message: 'OK', from_currency: params[:from_currency],to_currency: params[:to_currency] ,new_value: result }
	end
end

