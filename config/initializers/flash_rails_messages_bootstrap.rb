# frozen_string_literal: true

module FlashRailsMessages
  class Base
    # BOOTSTRAP FRAMEWORK
    # =========================================

    # TODO: uncomment if necessary to change the element behavior
    # def alert_element(type, message)
    #   content_tag :div, alert_options(type) do
    #     content = ActiveSupport::SafeBuffer.new
    #     content += close_element if options.fetch(:dismissible, false)
    #     content += message.html_safe
    #     content
    #   end
    # end

    def close_element
      tag.button type: 'button', class: 'btn-close', 'data-bs-dismiss': 'alert', 'aria-label': 'Close' do
      end
    end

    # TODO: uncomment if necessary to change default behavior
    # def default_alert_classes
    #   'alert'
    # end

    def alert_type_classes
      {
        success: 'alert-success',
        notice: 'alert-success',
        alert: 'alert-danger',
        error: 'alert-danger'
      }
    end

    def custom_alert_classes
      'alert-dismissible' if options.fetch(:dismissible) { false }
    end
  end
end
