class CreatePeymentTrials < ActiveRecord::Migration[7.0]
  def change
    create_table :peyment_trials do |t|
      t.string :phone_number
      t.integer :amount
      t.timestamps
      t.string "response"
      t.boolean "state", default: false
      t.string "code"
      t.string "CheckoutRequestID"
      t.string "MerchantRequestID"
    end
  end
end
