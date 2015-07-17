module Dcmetro
  VERSION = "0.0.3"
end

### Changes in 0.0.2
#
# Updates the api calls to the new format
#
# Fixes a bug if multiple stations are returned
#
# Requires the use of an env variable for the API key
#
# Requires rest-client

### Changes in 0.0.3
#
# Adds station to station travel information
#
# Expanded test coverage
#
# Refactors code so that the Information Class merely returns information
# Any parsing is now done in the CLI application
#
# Bug: If no stations are returned app pukes
# Bug: Pentagon and Pentagon City confuses app