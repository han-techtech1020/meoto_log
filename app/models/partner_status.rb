class PartnerStatus < ApplicationRecord
  belongs_to :user

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :mood
  belongs_to :cycle

  validates :hp_percentage, presence: true
  validates :mood_id, presence: true
  validates :cycle_id, presence: true
end
