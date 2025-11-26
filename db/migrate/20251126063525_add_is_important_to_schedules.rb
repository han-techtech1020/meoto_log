class AddIsImportantToSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :schedules, :is_important, :boolean, default: false
  end
end
