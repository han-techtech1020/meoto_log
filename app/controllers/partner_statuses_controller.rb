class PartnerStatusesController < ApplicationController
  def create
    @partner_status = current_user.partner_statuses.new(partner_status_params)

    name = current_user.partner_name.presence || '妻'

    if @partner_status.save
      redirect_to root_path, notice: "#{name}のご機嫌度を更新しました！"
    else
      redirect_to root_path, alert: '更新に失敗しました'
    end
  end

  private

  def partner_status_params
    params.require(:partner_status).permit(:hp_percentage, :mood_id)
  end
end
