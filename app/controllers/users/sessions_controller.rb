class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest

    # ログイン前にデータをきれいにする！
    user.reset_guest_data

    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end
