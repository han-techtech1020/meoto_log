require 'rails_helper'

RSpec.describe Schedule, type: :model do
  before do
    @user = FactoryBot.create(:user) # ← Fakerでランダムなユーザーが作られます
    @schedule = FactoryBot.build(:schedule, user: @user) # scheduleの定義がない場合はbuildで手動作成も可ですが、今回は下のように書きます
  end

  # ※もしspec/factories/schedules.rb がまだない場合は、以下のコードを使ってください
  # （ある場合は factory :schedule を定義して create(:schedule) できますが、今回は手動buildのままでいきます）
  let(:user) { FactoryBot.create(:user) }
  let(:schedule) { user.schedules.build(title: '買い物', start_time: Date.tomorrow, is_important: false) }

  describe '予定の保存' do
    context '保存できる場合' do
      it 'タイトルと未来の日付があれば保存できる' do
        expect(schedule).to be_valid
      end
    end

    context '保存できない場合' do
      it 'タイトルが空だと保存できない' do
        schedule.title = ''
        schedule.valid?
        expect(schedule.errors.full_messages).to include('予定の内容を入力してください')
      end

      it '日時が空だと保存できない' do
        schedule.start_time = ''
        schedule.valid?
        expect(schedule.errors.full_messages).to include('日時を入力してください')
      end

      it '日時が「過去」だと保存できない' do
        schedule.start_time = Date.yesterday
        schedule.valid?
        expect(schedule.errors.full_messages).to include('日時は今日以降の日付にしてください')
      end
    end
  end
end
