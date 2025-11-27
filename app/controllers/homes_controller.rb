class HomesController < ApplicationController
  def index
    return unless user_signed_in?

    # 1. 妻のHP（既存）
    @latest_status = current_user.partner_statuses.last
    @partner_status = PartnerStatus.new

    # 2. 直近の振り返り（最新の相談1件を取得）
    @latest_consultation = current_user.consultations.last

    # 3. これからの予定（今日以降の日付で、重要フラグが立っていないもの）
    @upcoming_schedules = current_user.schedules
                                      .where(is_important: false)
                                      .where('start_time >= ?', Time.zone.now.beginning_of_day)
                                      .order(:start_time)

    # 4. 大切な日（今日以降の日付で、重要フラグが立っているもの）
    @important_schedules = current_user.schedules
                                       .where(is_important: true)
                                       .where('start_time >= ?', Time.zone.now.beginning_of_day)
                                       .order(:start_time)
  end
end
