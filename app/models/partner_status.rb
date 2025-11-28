class PartnerStatus < ApplicationRecord
  belongs_to :user

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :mood

  validates :hp_percentage, presence: true
  validates :mood_id, presence: true
end
