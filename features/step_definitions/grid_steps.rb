require 'selenium-webdriver'
require 'rspec/expectations'
require 'json'

When(/^I browse to google using (chrome|firefox) in selenium grid identified by GRID_SELENIUM env var then title should be 'Google'$/) do |browser|

  grid = ENV['GRID_SELENIUM']

  if grid.nil?
    raise "must define GRID_SELENIUM env var"
  end

  # https://chromedriver.chromium.org/capabilities
  # https://peter.sh/experiments/chromium-command-line-switches/

  $stdout.write ENV['BROWSER_OPTIONS']

  caps_chrome = JSON.parse( ENV['BROWSER_OPTIONS'] )

  #caps_chrome = { "goog:chromeOptions" => {"args" => [ "--no-sandbox", "--headless" ] } }

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
