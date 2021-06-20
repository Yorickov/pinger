# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logs', type: :request do
  let(:user1) { create(:user_with_sites) }
  let(:site) { user1.sites.first }
  let(:log) { create(:log, site: site) }
  let(:user2) { create(:user) }

  describe 'GET /index' do
    context 'as authenticated User' do
      before { sign_in(user1) }

      it 'returns 200' do
        get "/sites/#{site.id}/logs"

        expect(response).to have_http_status(:success)
      end
    end

    context 'as Guest' do
      it 'redirect to login form' do
        get "/sites/#{site.id}/logs"

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
