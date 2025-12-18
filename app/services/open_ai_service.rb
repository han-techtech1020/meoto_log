class OpenAiService
  require 'openai'

  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
  end

  def chat(user_input, partner_personality = nil)
    # 性格情報がある場合のみ、プロンプトに追加する文章を作る
    personality_prompt = if partner_personality.present?
                           "なお、妻の性格や特徴は以下の通りです：\n「#{partner_personality}」\nこの性格を考慮して、最適な接し方や言葉選びをアドバイスしてください。"
                         else
                           '' # なければ何もしない
                         end

    # AIへの「役割」と「命令」を定義（ここがプロンプトエンジニアリング！）
    system_prompt = <<~TEXT
      あなたは夫婦関係の専門家であり、論理的なカウンセラーです。
      #{personality_prompt}#{' '}
      ユーザー（夫）の悩みや発言に対して、以下の3つの要素を含むJSON形式で回答してください。

      1. advice: 妻の心理を解説し、夫がどう行動すべきかの具体的なアドバイス（150文字以内）

      2. mood_score: 入力された状況から推測される「妻の現在の機嫌・感情」を0〜100の数値で厳密に評価してください。
         - 妻が泣いている、怒っている、疲れている、不満がある場合：0〜39点（低い）
         - 特に問題がない、普通の状態：40〜69点（普通）
         - 妻が喜んでいる、笑っている、感謝している場合：70〜100点（高い）
         ※夫の行動の是非ではなく、あくまで「妻の状態」を基準に採点すること。

      3. ai_response: そのまま妻に送れる、または口頭で伝えるべき「模範解答」のセリフ

      回答は必ずJSON形式のみを返してください。余計な文章は不要です。
    TEXT

    response = @client.chat(
      parameters: {
        model: 'gpt-4o-mini', # 最新の軽量モデル（安くて賢い）
        messages: [
          { role: 'system', content: system_prompt },
          { role: 'user', content: user_input }
        ],
        response_format: { type: 'json_object' }, # 必ずJSONで返させる設定
        temperature: 0.7
      }
    )

    # AIからの返信（JSON文字列）を取り出して返す
    response.dig('choices', 0, 'message', 'content')
  end
end
