class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :partner_statuses
  has_many :consultations
  has_many :schedules

  validates :nickname, presence: true

  # 毎回ユニークなゲストユーザーを作成する
  def self.guest
    # "guest_" + "ランダムなID" + "@example.com" でユニークなメアドを作る
    unique_email = "guest_#{SecureRandom.uuid}@example.com"

    create!(
      email: unique_email,
      password: SecureRandom.urlsafe_base64,
      nickname: 'ゲストさん',
      partner_name: '奥さん'
    )
  end
end
