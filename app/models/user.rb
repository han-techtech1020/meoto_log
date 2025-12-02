class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :partner_statuses
  has_many :consultations
  has_many :schedules

  validates :nickname, presence: true

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64 # ランダムなパスワード
      user.nickname = 'ゲストさん' # 必須項目なので設定
      user.partner_name = '奥さん' # デフォルトの呼び名
      # もし性格なども入れたければここに追加できます
    end
  end
end
