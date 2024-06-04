require 'open3'

module Planter
  module_function

  class CommandError < StandardError; end

  def plant(repo_name, user_name)
    unless Dir.exist?("../#{repo_name}")
      Dir.mkdir("../#{repo_name}")
      File.open("../#{repo_name}/garden.txt", 'w')
    end

    puts 'Initializing git and adding origin to remote...'
    run_command("cd ../#{repo_name} && git init && git remote add origin https://github.com/#{user_name}/#{repo_name}")

    generate_past_commits(repo_name)

    puts 'Pushing up to remote...'
    run_command("cd ../#{repo_name} && git push -u origin main -f")
  rescue Errno::EEXIST => e
    puts "Failed to create directory: #{e.message}"
  rescue Planter::CommandError => e
    puts e
  end

  def run_command(command)
    stdout, stderr, status = Open3.capture3(command)

    raise Planter::CommandError, "Error running command #{command}: #{stderr}" if status != 0

    puts stdout
  end

  def generate_past_commits(repo_name)
    year_before = Time.now - 31_536_000

    # Just an arbituary number
    300.times do
      date = rand(year_before...Time.now).strftime('%F %T')

      puts "Appending text 'I am planting a tree on #{date}' to garden.txt..."
      File.write(
        "../#{repo_name}/garden.txt",
        "\nI am planting a tree on #{date}",
        mode: 'a'
      )

      puts "commiting on date #{date}..."
      run_command("cd ../#{repo_name} &&
        git add . &&
        git commit --date='#{date}' -m 'Commited on #{date}'"
      )
    end
  end
end
