# frozen_string_literal: true

# == Schema Information
#
# Table name: logs
#
#  id            :bigint           not null, primary key
#  code          :integer
#  response_time :integer
#  status        :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  site_id       :bigint           not null
#
# Indexes
#
#  index_logs_on_site_id  (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (site_id => sites.id)
#
FactoryBot.define do
  factory :log do
    status { 'MyString' }
    code { 1 }
    response_time { 1 }
    site
  end
end
