class AddAddressToPeople < ActiveRecord::Migration[5.2]
  def change
      add_column :people, :address, :string
  end
end
