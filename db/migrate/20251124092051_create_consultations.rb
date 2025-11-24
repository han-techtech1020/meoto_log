class CreateConsultations < ActiveRecord::Migration[7.1]
  def change
    create_table :consultations do |t|
      t.text :content
      t.text :ai_response
      t.integer :risk_score
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
