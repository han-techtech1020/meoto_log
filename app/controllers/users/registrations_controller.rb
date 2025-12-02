class Users::RegistrationsController < Devise::RegistrationsController
  # アカウント情報の更新時の処理を上書き
  def update
    super
  end

  protected

  # パスワードなしで更新できるようにする魔法のメソッド
  def update_resource(resource, params)
    # 「ゲストユーザー」の場合
    if resource.email == 'guest@example.com'
      # パスワードなしで更新を許可する
      resource.update_without_password(params)
    else
      # 通常ユーザーは今まで通り（パスワード必須）
      super
    end
  end
end
