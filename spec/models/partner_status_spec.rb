require 'rails_helper'

RSpec.describe PartnerStatus, type: :model do
  before do
    @partner_status = FactoryBot.build(:partner_status)
  end

  describe 'ご機嫌度の記録' do
    context '保存できる場合' do
      it '全ての項目があれば保存できる' do
        expect(@partner_status).to be_valid
      end
    end

    context '保存できない場合' do
      it 'ご機嫌度（数値）が空だと保存できない' do
        @partner_status.hp_percentage = nil
        @partner_status.valid?
        expect(@partner_status.errors.full_messages).to include('ご機嫌度を入力してください')
      end

      it 'コンディションが空だと保存できない' do
        @partner_status.mood_id = nil
        @partner_status.valid?
        expect(@partner_status.errors.full_messages).to include('コンディションを入力してください')
      end

      it 'ユーザーが紐付いていないと保存できない' do
        @partner_status.user = nil
        @partner_status.valid?
        expect(@partner_status.errors.full_messages).to include('ユーザーを入力してください')
      end
    end
  end
end
