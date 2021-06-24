# frozen_string_literal: true

module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
      redirect_to root_path, alert: t('message.admin_required') unless current_user.try(:admin?)
    end
  end
end
