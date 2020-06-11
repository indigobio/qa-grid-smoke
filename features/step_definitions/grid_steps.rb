require 'selenium-webdriver'
require 'rspec/expectations'

When(/^I browse to google using (chrome|firefox) in selenium grid identified by GRID_SELENIUM env var then title should be 'Google'$/) do |browser|

  grid = ENV['GRID_SELENIUM']

  if grid.nil?
    raise "must define GRID_SELENIUM env var"
  end

  caps = case browser
           when 'chrome'
             Selenium::WebDriver::Remote::Capabilities.chrome()
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
