# frozen_string_literal: true

module MockHelpers
  def stub_valid_request(url, status, body = '')
    stub_request(:get, url)
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Faraday v1.4.2'
        }
      ).to_return(status: status, body: body, headers: {})
  end

  def stub_error_request(url)
    stub_request(:get, url).to_raise(StandardError)
  end

  def mock_ping_http_client(site, response)
    allow(Clients::HttpRequest)
      .to receive(:call)
      .with(site.full_url)
      .and_return(response)
  end
end
