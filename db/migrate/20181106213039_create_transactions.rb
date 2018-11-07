class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
    	t.references :person
    	t.references :item
    	t.datetime :date
    	t.integer :status
      t.timestamps
    end
  end
end