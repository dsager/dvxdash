require './lib/app_signal_connector'

appsignal_api_token = ENV['APPSIGNAL_API_TOKEN']
appsignal_api_site = '56a9fab1776f721815dc5902'

SCHEDULER.every '5m' do
  app_signal = AppSignalConnector.new(
    site: appsignal_api_site,
    token: appsignal_api_token
  )
  send_event(
    'appsignal_response_time',
    series_1: app_signal.mean_response_time,
    series_2: app_signal.pct_response_time,
  )
  send_event('appsignal_throughput', series_1: app_signal.throughput)
  send_event('appsignal_error_rate', series_1: app_signal.error_rate)
end
