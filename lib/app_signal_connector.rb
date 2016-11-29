require 'httparty'

class AppSignalConnector
  attr_reader :site, :token, :data

  def initialize(site:, token:)
    @site = site
    @token = token
    load_data
  end

  def mean_response_time
    data.map do |row|
      {
        x: row['timestamp'],
        y: row['mean'].round(2)
      }
    end
  end

  def pct_response_time
    data.map do |row|
      {
        x: row['timestamp'],
        y: row['pct'].round(2)
      }
    end
  end

  def throughput
    data.map do |row|
      {
        x: row['timestamp'],
        y: row['count'].to_i
      }
    end
  end

  def error_rate
    data.map do |row|
      {
        x: row['timestamp'],
        y: row['ex_rate'].round(2)
      }
    end
  end

  private

  # data should contain an array of objects like the following:
  # {
  #   "timestamp"=>1480050000,
  #   "count"=>29248.0,
  #   "mean"=>90.32640190970346,
  #   "pct"=>117.3225483329808,
  #   "ex_rate"=>0.12190970346225
  # }
  def load_data
    response = api_call
    json = JSON.parse(response.body)
    @data = (!json || json['data'].empty?) ? {} : json['data']
  end

  def api_call
    HTTParty.get(api_url, headers: { 'Accept' => 'application/json' })
  end

  def api_url
    "https://appsignal.com/api/#{site}/graphs.json?" \
      "token=#{token}" \
      "&from=#{api_url_from_parameter}" \
      '&kind=web' \
      '&fields[]=count' \
      '&fields[]=mean' \
      '&fields[]=pct' \
      '&fields[]=ex_rate'
  end

  def api_url_from_parameter
    # 13 hours ago
    DateTime.now - (13/24.0)
  end
end
