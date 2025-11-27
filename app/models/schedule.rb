class Schedule < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :start_time, presence: true
  validate :start_time_cannot_be_in_the_past

  private

  # ▼▼▼ この部分（中身）が必要です！ ▼▼▼
  def start_time_cannot_be_in_the_past
    # 日付が入っていて、かつ「今日より前（過去）」ならエラーにする
    return unless start_time.present? && start_time < Date.today

    errors.add(:start_time, 'は今日以降の日付にしてください')
  end
end
