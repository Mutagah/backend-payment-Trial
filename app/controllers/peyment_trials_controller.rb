class PeymentTrialsController < ApplicationController

    def index
        payment = Payment.all
    end

    def payment
        if params.present?
            # anything that in not contained in 0-9 a-z and A-Z is converted to an empty string
            # Confirming if the phone number is valid
            phone = PhonyRails.normalize_number(params[:phone_number], country_code: "KE").gsub(/\W/,'')
            payment = Payment.new({ amount: params[:amount], phone_number: phone })

            if payment.save
                # redirect_to root_path, :flash => {:success => "Payment Created, Check Mobile device"}
                render json:{success: "Payment Created,check Mobile device"}
            else
                # redirect_to root_path, :flash => {:error => "Payment failed"}
                render json:{error: "Payment Failed"}
            end
        end
    rescue Exception => e
        p e.message
    end

    def callback
        merchantrequestID = params[:Body][:stkCallback][:MerchantRequestID]
        checkoutrequestID = params[:Body][:stkCallback][:CheckoutRequestID]
        
        amount, mpesareceiptnumber,transactiondate,phonenumber = nil 
        if params[:Body][:stkCallback][:callbackMetadata].present?
            params[:Body][:stkCallback][:CallbackMetadata][:Item].each do |item|
                case item[:Name].downcase
                when "amount"
                    amount = item[:Value]
                when 'mpesareceiptnumber'
                    mpesareceiptnumber = item[:Value]
                  when 'transactiondate'
                    transactiondate = item[:Value]
                  when 'phonenumber'
                    phonenumber = item[:Value]
                  end
                end
        
        pay = PeymentTrial.find_by(amount: amount, phone_number: phonenumber, CheckoutRequestID: checkoutrequestID, MerchantRequestID: merchantrequestID)
                pay.state = true
                pay.code = mpesareceiptnumber
                pay.save
          
                render json: 'received'
              else
                pay = Payment.find_by(CheckoutRequestID: checkoutrequestID, MerchantRequestID: merchantrequestID)
                pay.code = params["Body"]["stkCallback"]["ResultDesc"]
                pay.save
              end
            Transaction.create({ callback: params })
            end
    end
    # def create
    #     payment = PeymentTrial.create!(payment_params)
    #     render json: payment, status: :created
    # end
    
    # private
    # def payment_params
    #     params.permit(:phone_number, :amount)
    # end
end
