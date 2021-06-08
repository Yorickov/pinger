# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SitePolicy, type: :policy do
  subject { described_class.new(user, site) }

  let(:site) { build(:site) }

  context 'for a Guest' do
    let(:user) { nil }

    it { should forbid_actions(%i[edit show update destroy ping]) }
  end

  context 'for a User' do
    let(:user) { build(:user) }

    context 'who added site' do
      let(:site) { build(:site, user: user) }

      it { should permit_actions(%i[edit show update destroy ping]) }
    end

    context 'who did not add site' do
      it { should forbid_actions(%i[edit show update destroy ping]) }
    end
  end
end
