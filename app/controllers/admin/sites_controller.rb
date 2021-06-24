# frozen_string_literal: true

module Admin
  class SitesController < Admin::ApplicationController
    def valid_action?(name, resource = resource_class)
      %w[new].exclude?(name.to_s) && super
    end
  end
end
