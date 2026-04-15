ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# Bootsnap may fail on Windows when workspace paths contain non-ASCII characters.
disable_bootsnap = ENV["DISABLE_BOOTSNAP"] == "1" || Gem.win_platform?
require "bootsnap/setup" unless disable_bootsnap # Speed up boot time by caching expensive operations.
