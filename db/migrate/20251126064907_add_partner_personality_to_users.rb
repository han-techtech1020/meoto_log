class AddPartnerPersonalityToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :partner_personality, :text
  end
end
