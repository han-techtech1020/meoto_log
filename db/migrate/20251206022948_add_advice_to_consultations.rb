class AddAdviceToConsultations < ActiveRecord::Migration[7.1]
  def change
    add_column :consultations, :advice, :text
  end
end
