require 'selenium-webdriver'
require 'rspec/expectations'
require 'json'

require_relative '../../grid_api_client'

When(/^I browse to google using (chrome|firefox) in selenium grid identified by GRID_SELENIUM env var then title should be 'Google'$/) do |browser|

  grid = ENV['GRID_SELENIUM']

  if grid.nil?
    raise "must define GRID_SELENIUM env var"
  end

  grid_api = GridAPIclient.new( addr: grid.gsub('/wd/hub','') )
  grid_api.grid_api_hub

  # https://chromedriver.chromium.org/capabilities
  # https://peter.sh/experiments/chromium-command-line-switches/

  #$stdout.write ENV['GOOG_CHROMOPTIONS_ARGS']

  goog_chromeoptions_args = ENV['GOOG_CHROMOPTIONS_ARGS'].nil? ? [] : ENV['GOOG_CHROMOPTIONS_ARGS'].split(' ')

  caps_chrome = { "goog:chromeOptions" => {"args" => goog_chromeoptions_args } }

  caps = case browser
           when 'chrome'
             Selenium::WebDriver::Remote::Capabilities.chrome(caps_chrome)
           when 'firefox'
             Selenium::WebDriver::Remote::Capabilities.firefox()
           else
             raise "#{browser} not supported"
           end

 brow = Selenium::WebDriver.for(:remote, :url => grid, :desired_capabilities => caps)

  begin

    brow.get('http://google.com')

    expect( brow.title ).to eq( 'Google' )

  rescue Exception => e
    raise
  ensure
    brow.quit rescue ''
  end

end
