class CreatePeymentTrials < ActiveRecord::Migration[7.0]
  def change
    create_table :peyment_trials do |t|
      t.string :phone_number
      t.integer :amount

      t.timestamps
    end
  end
end
