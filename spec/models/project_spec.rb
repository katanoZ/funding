require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'scope' do
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

  describe '#investments_amount' do
    let(:project) { create(:project) }
    subject { project.investments_amount }

    context 'プロジェクトが出資されている場合' do
      before do
        create(:investment, price: 1000, project: project)
        create(:investment, price: 2000, project: project)
        create(:investment, price: 3000, project: project)
      end

      it '出資額が正しいこと' do
        is_expected.to eq 6000
      end
    end

    context 'プロジェクトが出資されていない場合' do
      before do
        create(:investment, price: 1000)
        create(:investment, price: 2000)
        create(:investment, price: 3000)
      end

      it '出資額が正しいこと' do
        is_expected.to eq 0
      end
    end
  end
end
