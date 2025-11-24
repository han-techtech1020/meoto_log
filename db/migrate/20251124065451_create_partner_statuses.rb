class CreatePartnerStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :partner_statuses do |t|
      t.integer :hp_percentage
      t.integer :mood_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
