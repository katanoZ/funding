require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { create(:user) }
  let(:guest) { create(:user) }

  # 検証対象のプロジェクト
  let!(:owner_project_not_invested) { create(:project, owner: user) }
  let!(:owner_project_invested_by_guest) { create(:project, owner: user) }
  let!(:not_owner_project_not_invested) { create(:project) }
  let!(:not_owner_project_invested_by_guest) { create(:project) }
  let!(:not_owner_project_invested_by_user) { create(:project) }

  before do
    # プロジェクトに出資する
    create(:investment, project: owner_project_invested_by_guest, user: guest)
    create(:investment, project: not_owner_project_invested_by_guest, user: guest)
    create(:investment, project: not_owner_project_invested_by_user, user: user)
  end

  describe '.investable' do
    it 'ユーザがオーナーではない、かつ、ユーザーが出資していないプロジェクトが返ること' do
      expect(Project.investable(user))
        .to contain_exactly not_owner_project_not_invested,
                            not_owner_project_invested_by_guest
    end
  end

  describe '.not_owned_by' do
    it 'ユーザがオーナーではないプロジェクトが返ること' do
      expect(Project.not_owned_by(user))
        .to contain_exactly not_owner_project_not_invested,
                            not_owner_project_invested_by_guest,
                            not_owner_project_invested_by_user
    end
  end

  describe '.not_invested_by' do
    it 'ユーザが出資していないプロジェクトが返ること' do
      expect(Project.not_invested_by(user))
        .to contain_exactly owner_project_not_invested,
                            owner_project_invested_by_guest,
                            not_owner_project_not_invested,
                            not_owner_project_invested_by_guest
    end
  end
end
