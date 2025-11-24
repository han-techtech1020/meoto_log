class HomesController < ApplicationController
  def index
    # ログインしている場合のみデータを取得
    return unless user_signed_in?

    # 最新のステータスを取得（表示用）
    @latest_status = current_user.partner_statuses.last

    # 新しいステータス作成用（フォーム用）
    @partner_status = PartnerStatus.new
  end
end
