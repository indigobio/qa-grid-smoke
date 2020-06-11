Feature: Selenium Grid

  Scenario Outline: Browser

    When I browse to google using <browser> in selenium grid identified by GRID_SELENIUM env var then title should be 'Google'

    Examples:
      |browser|
      |chrome |
#      |firefox|
