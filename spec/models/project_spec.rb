require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { create(:user) }

  describe '.investable' do
    context '該当のデータが存在する場合' do
      let(:project) { create(:project) }
      let(:results) { Project.investable(user) }

      before do
        create(:investment, project: project)
      end

      it '件数が正しいこと' do
        expect(results.count).to eq 1
      end

      it '内容が正しいこと' do
        expect(user.owner?(results.first)).to be_falsey
        expect(user.invest_in?(results.first)).to be_falsey
      end
    end

    context '該当のデータが存在しない場合' do
      let(:project) { create(:project) }
      let(:results) { Project.investable(user) }

      before do
        create(:project, owner: user)
        create(:investment, project: project, user: user)
      end

      it '件数が正しいこと' do
        expect(results.count).to eq 0
      end
    end
  end

  describe '.not_owned_by' do 
    context '該当のデータが存在する場合' do
      let!(:project) { create(:project) }
      let!(:results) { Project.not_owned_by(user) }

      it '件数が正しいこと' do
        expect(results.count).to eq 1
      end

      it '内容が正しいこと' do
        expect(user.owner?(results.first)).to be_falsey
      end
    end

    context '該当のデータが存在しない場合' do
      let!(:project) { create(:project, owner: user) }
      let!(:results) { Project.not_owned_by(user) }

      it '件数が正しいこと' do
        expect(results.count).to eq 0
      end
    end
  end

  describe '.not_invested_by' do
    context '該当のデータが存在する場合' do
      let(:project) { create(:project) }
      let(:results) { Project.not_invested_by(user) }

      before do
        create(:investment, project: project)
      end

      it '件数が正しいこと' do
        expect(results.count).to eq 1
      end

      it '内容が正しいこと' do
        expect(user.invest_in?(results.first)).to be_falsey
      end
    end

    context '該当のデータが存在しない場合' do
      let(:project) { create(:project) }
      let(:results) { Project.not_invested_by(user) }

      before do
        create(:investment, project: project, user: user)
      end

      it '件数が正しいこと' do
        expect(results.count).to eq 0
      end
    end
  end
end
