class ChargesController < ApplicationController

	def create
	  # Amount in cents
	  product = Product.find(params[:product_id].to_i)
	  address = params[:address]
	  phone = params[:phone_number]
	  email = params[:stripeEmail]
	  requests = params[:requests]

	  quantity = params[:quantity].to_i || 1
	  price = product.price * quantity

	  customer = Stripe::Customer.create(
	    :email => email,
	    :source  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount => price * 100,
	    :description => product.title,
	    :currency => 'usd',
	    :metadata => {
	    	"email" => email,
	    	"requests" => requests,
	    	"quantity" => quantity
	    }
	  )

	  @sale = Sale.create!(
        email: email,
        stripe_id:  charge.id,
        amount: price,
        requests: requests,
        phone_number: phone,
        quantity: quantity,
        product_id: product.id
      )

	  require "rushover"

	  user_key = "uo22v1siadqnfe6u85m4put9bjcu49"
	  your_app_token = "a1kvq1274ddxzb5rt8tizvysagahp6"

	  client = Rushover::Client.new(your_app_token)
	  resp = client.notify(user_key, "$#{@sale.amount}: #{quantity} #{product.title} - #{@sale.phone_number}", :priority => 1, :title => "$#{@sale.amount}")
	  resp.ok? # => true
      redirect_to thanks_path(guid: @sale.guid)

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to new_charge_path
	end

	def thanks
		@sale = Sale.find_by!(guid: params[:guid])
	end
end