# qa-grid-smoke
smoke test for remote selenium grid

Local grid is defined in docker-compose.yml file which is taken from https://github.com/SeleniumHQ/docker-selenium#version-3

GRID_SELENIUM env var must be defined in same process when running tests.

example:

```GRID_SELENIUM=http://localhost:4444/wd/hub bundle exec cucumber```


To run grid locally, see instructions at top of docker-compose.yml file.