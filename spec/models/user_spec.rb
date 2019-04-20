require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#owner?' do
    subject { user.owner?(project) }

    context 'ユーザがプロジェクトのオーナーの場合' do
      let(:project) { create(:project, owner: user) }

      it '結果が正しいこと' do
        is_expected.to be true
      end
    end

    context 'ユーザがプロジェクトのオーナーでない場合' do
      let(:project) { create(:project) }

      it '結果が正しいこと' do
        is_expected.to be false
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
        is_expected.to be true
      end
    end

    context 'ユーザがプロジェクトに出資していない場合' do
      before do
        create(:investment, project: project)
      end

      it '結果が正しいこと' do
        is_expected.to be false
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

  describe '#like!' do
    context 'ユーザがプロジェクトに「いいね」をしていない場合' do
      let(:project) { create(:project) }

      it '結果が正しいこと' do
        expect { user.like!(project) }.to change { user.liked?(project) }
          .from(false).to(true)
      end
    end

    context 'ユーザがプロジェクトに「いいね」をしている場合' do
      let(:project) { create(:project) }
      before { user.like!(project) }

      it 'エラーが発生すること' do
        expect { user.like!(project) }.to raise_error(/に既にいいね済みです/)
      end
    end

    context 'ユーザがプロジェクトのオーナーの場合' do
      let(:project) { create(:project, owner: user) }

      it 'エラーが発生すること' do
        expect { user.like!(project) }.to raise_error(/のオーナーはいいねできません/)
      end
    end
  end

  describe '#remove_like!' do
    let(:project) { create(:project) }

    context 'ユーザがプロジェクトに「いいね」をしている場合' do
      before { user.like!(project) }

      it '結果が正しいこと' do
        expect { user.remove_like!(project) }.to change { user.liked?(project) }
          .from(true).to(false)
      end
    end

    context 'ユーザがプロジェクトに「いいね」をしていない場合' do
      it 'エラーが発生すること' do
        expect { user.remove_like!(project) }.to raise_error 'プロジェクトにいいねしていません'
      end
    end
  end

  describe 'liked?' do
    let(:project) { create(:project) }
    subject { user.liked?(project) }

    context 'ユーザがプロジェクトに「いいね」をしている場合' do
      before { user.like!(project) }

      it '結果が正しいこと' do
        is_expected.to be true
      end
    end

    context 'ユーザがプロジェクトに「いいね」をしていない場合' do
      before do
        other_user = create(:user)
        other_user.like!(project)

        other_project = create(:project)
        user.like!(other_project)
      end

      it '結果が正しいこと' do
        is_expected.to be false
      end
    end
  end
end
