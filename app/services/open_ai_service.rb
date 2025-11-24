class OpenAiService
  require 'openai'

  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
  end

  def chat(user_input)
    # AIへの「役割」と「命令」を定義（ここがプロンプトエンジニアリング！）
    system_prompt = <<~TEXT
      あなたは夫婦関係の改善をサポートする論理的なカウンセラーです。
      ユーザー（夫）の悩みや発言に対して、以下の3つのキーを持つJSON形式のみで回答してください。余計な挨拶や文章は不要です。

      1. advice: 妻の心理を分析し、夫がどう行動すべきかの具体的アドバイス（100文字以内）
      2. risk_score: その発言や行動の夫婦仲悪化リスクを0〜100の数値で評価（高いほど危険）
      3. ai_response: 妻に対してそのまま使える「模範解答」となるセリフ

      回答例:
      {
        "advice": "奥様は共感を求めています。解決策を急ぐのは逆効果です。",
        "risk_score": 80,
        "ai_response": "大変だったね。話してくれてありがとう。"
      }
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
