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
    current_cycle = current_user.partner_statuses.last&.cycle&.name || '不明' # 最新のステータスから周期情報を取得（なければ'不明'）
    full_input = "【現在の妻の周期状態：#{current_cycle}】\n相談内容：#{user_input}" # AIに渡す最終的な文章を作成
    partner_personality = current_user.partner_personality # 現在のユーザーの登録しているパートナー性格を取得
    service = OpenAiService.new
    response_string = service.chat(full_input, partner_personality) # ここでAIと通信（数秒かかる）

    # 3. 返ってきたJSON文字を、Rubyで扱えるように変換（パース）する
    response_data = JSON.parse(response_string)

    # 4. データベースに保存する
    @consultation = current_user.consultations.new(
      content: user_input,
      ai_response: response_data['ai_response'], # 模範解答
      risk_score: response_data['mood_score'], # ご機嫌度スコア
      advice: response_data['advice'] # アドバイス
    )

    if @consultation.save
      new_status = update_partner_status_automatically(@consultation.risk_score) # 自動更新ロジック

      # 5. 成功したら、画面（JavaScript）にデータを返す
      render json: {
        ai_response: @consultation.ai_response,
        risk_score: @consultation.risk_score,
        advice: response_data['advice'], # アドバイスも画面には表示したいので返す
        new_hp: new_status.hp_percentage,
        new_mood: new_status.mood.name
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

  private

  # HP自動計算メソッド
  def update_partner_status_automatically(mood_score)
    # 1. 時間によるベースHP算出ロジック
    current_hour = Time.current.hour
    # 基準：朝7時起床とする
    base_hp = if current_hour >= 7
                # 【日中〜夜 (07:00 〜 23:59)】
                # 7時からの経過時間 × 5 を引く
                # 例: 7時=100, 12時=75, 19時=40, 23時=20
                elapsed_hours = current_hour - 7
                100 - (elapsed_hours * 5)
              else
                # 【深夜〜早朝 (00:00 〜 06:59)】
                # 基本的に寝ているか、起きていても疲れている時間帯なので低めに固定
                20
              end

    # 2. ご機嫌度(mood_score)による補正
    # 50点を基準に、良ければプラス、悪ければマイナス
    # 例: 80点なら +15, 20点なら -15
    mood_impact = (mood_score - 50) / 2

    # 3. 合算 (0〜100の範囲に収める)
    final_hp = (base_hp + mood_impact).clamp(0, 100)

    # 4. コンディション(mood_id)の自動選択
    estimated_mood_id = case mood_score
                        when 80..100 then 1 # 最高
                        when 60..79  then 2 # 良い
                        when 40..59  then 3 # 普通
                        when 20..39  then 4 # やや不機嫌
                        else              5 # 不機嫌
                        end

    # 5. 周期目安
    last_status = current_user.partner_statuses.last
    current_cycle_id = last_status&.cycle_id # 直前の値を取得（なければnil）

    # 6. 保存
    current_user.partner_statuses.create(
      hp_percentage: final_hp,
      mood_id: estimated_mood_id,
      cycle_id: current_cycle_id
    )
  end
end
