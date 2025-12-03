class PartnerStatusesController < ApplicationController
  def create
    @partner_status = current_user.partner_statuses.new(partner_status_params)

    name = current_user.partner_name.presence || '妻'

    if @partner_status.save
      redirect_to root_path, notice: "#{name}のコンディションを変更しました！"
    else
      redirect_to root_path, alert: 'コンディションを入力してください'
    end
  end

  private

  def partner_status_params
    params.require(:partner_status).permit(:hp_percentage, :mood_id)
  end
end
