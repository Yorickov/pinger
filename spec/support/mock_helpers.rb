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

  def stub_error_request(url, error_type)
    stub_request(:get, url).to_raise(error_type)
  end

  def mock_http_client(url, response, options = {})
    allow(HttpClient)
      .to receive(:call)
      .with(url, options)
      .and_return(response)
  end
end
