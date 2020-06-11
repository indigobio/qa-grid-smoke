Feature: Selenium Grid

  Scenario: Chrome

    When I browse to google using chrome in selenium grid identified by GRID_SELENIUM env var then title should be 'Google'
