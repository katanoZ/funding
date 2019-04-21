require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#owner?' do
    subject { user.owner?(project) }

    context 'ユーザがプロジェクトのオーナーの場合' do
      let(:project) { create(:project, owner: user) }

      it '結果が正しいこと' do
        is_expected.to be_truthy
      end
    end

    context 'ユーザがプロジェクトのオーナーでない場合' do
      let(:project) { create(:project) }

      it '結果が正しいこと' do
        is_expected.to be_falsey
      end
    end
  end

  describe '#invest_in?' do
    let(:project) { create(:project) }
    subject { user.invest_in?(project) }

    context 'ユーザがプロジェクトに出資している場合' do
      before do
        create(:investment, project: project, user: user)
      end

      it '結果が正しいこと' do
        is_expected.to be_truthy
      end
    end

    context 'ユーザがプロジェクトに出資していない場合' do
      before do
        create(:investment, project: project)
      end

      it '結果が正しいこと' do
        is_expected.to be_falsey
      end
    end
  end

  describe '#investment_amount' do
    let(:project) { create(:project) }
    subject { user.investment_amount(project) }

    context 'ユーザがプロジェクトに出資している場合' do
      before do
        create(:investment, project: project, price: 1000, user: user)
        create(:investment, project: project, price: 3000)
      end

      it '出資額が正しいこと' do
        is_expected.to eq 1000
      end
    end

    context 'ユーザがプロジェクトに出資していない場合' do
      before do
        create(:investment, project: project, price: 3000)
      end

      it '出資額が正しいこと' do
        is_expected.to eq 0
      end
    end
  end

  describe '#like' do
    context 'ユーザがプロジェクトに「いいね」をしていない場合' do
      let!(:project) { create(:project) }
      let!(:result) { user.like(project) }

      it '結果が正しいこと' do
        expect(result).to be_truthy
      end

      it '内容が正しいこと' do
        expect(user.liked?(project)).to be_truthy
      end
    end

    context 'ユーザがプロジェクトに「いいね」をしている場合' do
      before { user.like(project) }
      let(:project) { create(:project) }
      let!(:result) { user.like(project) }

      it '結果が正しいこと' do
        expect(result).to be_falsey
      end

      it '内容が正しいこと' do
        expect(user.liked?(project)).to be_truthy
      end
    end

    context 'ユーザがプロジェクトのオーナーの場合' do
      let!(:project) { create(:project, owner: user) }
      let!(:result) { user.like(project) }

      it '結果が正しいこと' do
        expect(result).to be_falsey
      end

      it '内容が正しいこと' do
        expect(user.liked?(project)).to be_falsey
      end
    end
  end

  describe '#remove_like' do
    context 'ユーザがプロジェクトに「いいね」をしている場合' do
      before { user.like(project) }
      let(:project) { create(:project) }
      let!(:result) { user.remove_like(project) }

      it '結果が正しいこと' do
        expect(result).to be_truthy
      end

      it '内容が正しいこと' do
        expect(user.liked?(project)).to be_falsey
      end
    end

    context 'ユーザがプロジェクトに「いいね」をしていない場合' do
      let!(:project) { create(:project) }
      let!(:result) { user.remove_like(project) }

      it '結果が正しいこと' do
        expect(result).to be_falsey
      end

      it '内容が正しいこと' do
        expect(user.liked?(project)).to be_falsey
      end
    end
  end

  describe 'liked?' do
    let(:project) { create(:project) }
    subject { user.liked?(project) }

    context 'ユーザがプロジェクトに「いいね」をしている場合' do
      before { user.like(project) }

      it '結果が正しいこと' do
        is_expected.to be_truthy
      end
    end

    context 'ユーザがプロジェクトに「いいね」をしていない場合' do
      before do
        other_user = create(:user)
        other_user.like(project)

        other_project = create(:project)
        user.like(other_project)
      end

      it '結果が正しいこと' do
        is_expected.to be_falsey
      end
    end
  end
end
