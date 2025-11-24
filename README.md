erDiagram
    Users ||--o{ Consultations : "相談する"
    Users ||--o{ Partner_Statuses : "記録する"
    Users ||--o{ Schedules : "登録する"

    Users {
        integer id PK
        string nickname "ニックネーム"
        string email "メールアドレス"
        string password "パスワード"
    }

    Consultations {
        integer id PK
        text content "相談内容"
        text ai_response "AIの回答"
        integer risk_score "危険度スコア"
        references user_id FK
    }

    Partner_Statuses {
        integer id PK
        integer hp_percentage "妻のHP(%)"
        integer mood_id "機嫌(ActiveHash)"
        references user_id FK
    }

    Schedules {
        integer id PK
        string title "予定タイトル"
        datetime start_time "開始日時"
        references user_id FK
    }
