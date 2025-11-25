class SchedulesController < ApplicationController
  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = current_user.schedules.new(schedule_params)
    if @schedule.save
      redirect_to root_path, notice: '予定を追加しました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    schedule = current_user.schedules.find(params[:id])
    schedule.destroy
    redirect_to root_path, notice: '予定を削除しました'
  end

  private

  def schedule_params
    params.require(:schedule).permit(:title, :start_time)
  end
end
