class Phone < ActiveRecord::Base

    def self.send_message(to)

            # require 'phonelib'
            # require 'twilio-ruby' 

            # account_sid = '' 
            # auth_token = '' 
            # @client = Twilio::REST::Client.new(account_sid, auth_token) 

            # message = @client.messages.create( 
            #     body: 'Hi, Your Wikkys.com order is ready for pick-up! Please call us 704-201-7085 for any questions.', 
            #     from: Phonelib.parse("+").e164,     
            #     to: Phonelib.parse(to).e164
            # ) 

            require 'phonelib'
            require 'vonage'

            body = 'Hi, Your Umm Sukkar order is ready for pick-up! Please call us 704-201-7085 for any questions.'

            from = Phonelib.parse("+12679669134").e164
            to = Phonelib.parse(to).e164


            client = Vonage::Client.new(
                api_key: "98bea592",
                api_secret: "9KoDeiDF9qp8DhOP"
            )

            response = client.sms.send(
                from: from,
                to: to,
                text: body
            )

            response
    end
end