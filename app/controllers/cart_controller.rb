class CartController < ApplicationController

    skip_before_action :verify_authenticity_token

    def configure
        # session["cart"] = false
        if session["cart"].present?
        else
            session["cart"] = {
                "products" => [],
                "coupons" => [],
                "total" => 0,
            }
        end

        puts "############INIT########"
        puts session["cart"]

        case params[:config]
            when "add_product"
                puts "############Adding########"
                session["cart"]["products"].push({
                    "product_id" => params[:product_id],
                    "title" => params[:title],
                    "quantity" => params[:quantity],
                    "requests" => params[:requests],
                    "cost" => params[:cost]
                })
                    
                puts session["cart"]

            when "remove_product"
                
                y = [params["index"].to_i]
                list = session["cart"]["products"].reject.with_index { |e, i| y.include? i } #=> [2, 5]
                session["cart"]["products"] = list

                puts session["cart"]

            else

        end
        
        total = 0
        session["cart"]["products"].each do |p|
            puts "####COST###"
            puts p["cost"].to_i
            total = total + p["cost"].to_i
        end

        session["cart"]["total"] = total

        render status: 200, json: {
            cart: session["cart"],
        }.to_json
    end

    def create_payment_intent
        # Create a PaymentIntent with amount and currency
        payment_intent = Stripe::PaymentIntent.create(
            amount: params[:total],
            currency: 'usd',
            automatic_payment_methods: {
            enabled: true,
            },
        )

          render status: 200, json: payment_intent['client_secret']

    end

    # 
    def stripe_customer
        require 'stripe'

        Stripe::Customer.create({
            name: params[:name],
            phone: params[:phone],
        })

        
    end


    def checkout

		# ####################################################
		# This is used to make a new checkout page pop-up    
		# ####################################################
		
		if Rails.env.production?  #=> true  
			puts "PRODUCTION!!!"
			link = "http://www.wikkys.com"
		else
			puts "DEVELOPMENT!!!"
			link = "http://localhost:5173"
		end

        total = params[:total].to_i

        puts "META"
        puts params[:metadata]

        metadata = params[:metadata]

        puts metadata

        require 'spicy-proton'

        guid = Spicy::Proton.pair
        while Sale.where(guid: guid).present?
            guid = Spicy::Proton.pair
        end 
        

        @sale = Sale.create(
            guid: guid,
            invoice: params[:metadata][:invoice]
        )

        # json_string = JSON.generate(metadata)

        # JavaScript object
        # javascript_object = JSON.parse(json_string)
		# This is used to populate the checkout session content    
		# ####################################################
        session = Stripe::Checkout::Session.create({
            payment_method_types: ['card'],
            line_items: [{
                name: 'Order',
                description: params[:metadata][:invoice].map {|line| line[:quantity].to_s + "x " + line[:product][:title]}.join(", "),
                amount: total * 100,
                currency: 'usd',
                quantity: 1,
            }],
            
            mode: 'payment',
            # For now leave these URLs as placeholder values.
            #
            # Later on in the guide, you'll create a real success page, but no need to
            # do it yet.
            success_url: "#{link}/success/{CHECKOUT_SESSION_ID}",
		    cancel_url: "#{link}",
            phone_number_collection: {
                enabled: true,
            },
            metadata: {
                sale_id: @sale.id,
                sale_guid: @sale.guid
            }
        })


		render status: 200, json: {
	    	session: session,
        }.to_json
          
    end

    def success
        session["cart"] = nil


        puts "PARAMS"
        puts params[:session_id]
        session = Stripe::Checkout::Session.retrieve(params[:session_id])
        # customer = Stripe::Checkout::Customer.retrieve(session.customer)

        phone_number = session["customer_details"]["phone"]



        puts "########"
        puts session
        puts "PHONE NUMBER"
        puts phone_number
        
        email = Stripe::Customer.retrieve(session["customer"])["email"]
        puts "EMAIL"
        puts email


 
        @sale = Sale.find_by(guid: session["metadata"]["sale_guid"])
        if @sale.stripe_id.present? && @sale.phone_number.present?
        else


            
            @sale.update(
                    email: email,
                    phone_number: phone_number,
                    amount: session["amount_total"],
                    stripe_id: params[:session_id],
                )

            Phone.send_message(phone_number)
            
        end





        render json: {
            phone_number: phone_number,
            sale: @sale,
            session: session
        }
    end



end