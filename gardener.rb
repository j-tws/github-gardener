require_relative 'planter.rb'
require 'optparse'

module Gardener
  module_function

  def parse_input(input_args)
    options = {}

    OptionParser.new do |option|
      option.banner = 'Usage: ruby bin/gardener.rb -r [REPO_NAME] -u [USER_NAME]'

      option.on('-r', '--repo_name REPO_NAME', 'The name of the repo you created for this script') do |r|
        options[:repo_name] = r
      end

      option.on('-u', '--user_name USER_NAME', 'Your Github username') do |u|
        options[:user_name] = u
      end

      option.on('-h', '--help', 'Prints out available options') do
        puts option
      end
    end.parse(input_args)

    options
  end

  def execute
    input = ARGV
    options = parse_input(input)

    return if input.include?('-h')

    unless input.include?('-r') && input.include?('-u') && input.length != 2
      raise OptionParser::MissingArgument, 'Please enter required options and arguments for -r and -u. Use -h for more info'
    end

    Planter.plant(options[:repo_name], options[:user_name])
  end
end

Gardener.execute
