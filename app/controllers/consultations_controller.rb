class ConsultationsController < ApplicationController
  # CSRFトークンエラーを防ぐため（今回は簡易的なAjax対応）
  protect_from_forgery except: :create
  before_action :authenticate_user!

  def index
    # N+1問題を防ぐため、必要であればincludes等を追加してください
    @consultations = current_user.consultations.order(created_at: :desc)
  end

  def create
    # 1. フォームから送られてきた相談内容を取得
    user_input = params[:content]

    # 2. AIサービスを呼び出して相談する
    partner_personality = current_user.partner_personality # 現在のユーザーの登録しているパートナー性格を取得
    service = OpenAiService.new
    response_string = service.chat(user_input, partner_personality) # ここでAIと通信（数秒かかる）

    # 3. 返ってきたJSON文字を、Rubyで扱えるように変換（パース）する
    response_data = JSON.parse(response_string)

    # 4. データベースに保存する
    @consultation = current_user.consultations.new(
      content: user_input,
      ai_response: response_data['ai_response'], # 模範解答
      risk_score: response_data['mood_score']    # ご機嫌度スコア
    )

    if @consultation.save
      # 5. 成功したら、画面（JavaScript）にデータを返す
      render json: {
        ai_response: @consultation.ai_response,
        risk_score: @consultation.risk_score,
        advice: response_data['advice'] # アドバイスも画面には表示したいので返す
      }
    else
      render json: { error: '保存に失敗しました' }, status: :unprocessable_entity
    end
  end

  def destroy
    consultation = current_user.consultations.find(params[:id])
    consultation.destroy

    # 一覧ページへ戻り、メッセージを表示
    redirect_to consultations_path, notice: '履歴を削除しました'
  end
end
