class AddPartnerNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :partner_name, :string
  end
end
