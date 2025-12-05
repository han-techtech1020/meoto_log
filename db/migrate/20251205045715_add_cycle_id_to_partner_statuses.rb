class AddCycleIdToPartnerStatuses < ActiveRecord::Migration[7.1]
  def change
    add_column :partner_statuses, :cycle_id, :integer
  end
end
