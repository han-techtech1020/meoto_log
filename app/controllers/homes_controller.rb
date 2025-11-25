class HomesController < ApplicationController
  def index
    return unless user_signed_in?

    # 1. 妻のHP（既存）
    @latest_status = current_user.partner_statuses.last
    @partner_status = PartnerStatus.new

    # 2. 直近の振り返り（最新の相談1件を取得）
    @latest_consultation = current_user.consultations.last

    # 3. 本日の予定（今日の0:00〜23:59の予定を取得）
    @today_schedules = current_user.schedules.where(start_time: Time.zone.now.all_day).order(:start_time)
  end
end
