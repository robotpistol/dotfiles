#!ruby

# usage: copy into your $WORK_DIR_PATH (probably chmod +x), run w/ ./scoreboard 'Your Name'

# TODO: exclude certain file globs then re-include chime-cd
def repo_stats(author, repo)
  log_opts = "--since='20 years ago' --author='#{author}' --numstat --format=''"
  log_command="git log #{log_opts} | cut -f 1-2"
  commit_count_command="git shortlog -sn | grep '#{author}'"

  Dir.chdir(repo) do
    commits = `#{commit_count_command}`.chomp.to_i

    stats = { repo: repo, added: 0, removed: 0, commits: commits }
    `#{log_command}`
      .split(/\s+/)
      .map(&:to_i)
      .each_slice(2)
      .each_with_object(stats) { |pair,total|
        total[:added] += pair[0]
        total[:removed] += pair[1]
      }
  end
end

def collect_stats(author, waiting_proc)
  Dir.foreach(".").map { |dir|
    next unless File.directory?(dir)
    next unless File.exist?("#{dir}/.git")
    next if dir == "chime-cd" # configs generate fake giant diffs
	next if dir == "chime-schemas" # schemas generate fake giant diffs

    waiting_proc.call
    repo_stats(author, dir)
  }.compact
    .reject { |stat| stat[:added] == 0 && stat[:removed] == 0 }
    .sort_by { |stat| stat[:added] + stat[:removed] }
    .reverse
end

def zsh_color(color_name, text)
  color = case color_name
          when "green" then 32
          when "red" then 31
          when "yellow" then 33
          else raise ArgumentError
          end

  "\e[#{color}m#{text}\e[0m"
end
def print_repo_stats(stats)
  green = '🟩'
  red = '🟥'
  add_blocks = ((stats[:added].to_f / (stats[:added] + stats[:removed])) * 5).round
  remove_blocks = 5 - add_blocks

  print (green * add_blocks) + (red * remove_blocks)
  print "  #{stats[:repo]}, #{zsh_color("yellow", stats[:commits])} commits, +#{zsh_color('green',stats[:added])} / -#{zsh_color("red", stats[:removed])}"
  print "\n"
end

def print_summary_stats(stats)
  totals = stats.each_with_object({ added: 0, removed: 0, commits: 0 }) do |repo, total|
    total[:commits] += repo[:commits]
    total[:added] += repo[:added]
    total[:removed] += repo[:removed]
  end

  puts "\nTotal: " \
    "#{zsh_color("yellow", totals[:commits])} commits, " \
    "#{zsh_color("green", totals[:added])} added, "\
    "#{zsh_color("red", totals[:removed])} removed " \
    "in #{stats.length} cloned repos"

  net = totals[:added] - totals[:removed]
  if net > 0
    puts "Total positivity: #{zsh_color('green', net)}"
  else
    puts "Total negativity: #{zsh_color('red', net)}"
  end
end

def print_all_stats(total_stats, top:)
  total_stats.first(top).each do |stat|
    print_repo_stats(stat)
  end

  if total_stats.length > top
    puts "... plus #{total_stats.length - top} more"
  end
  print_summary_stats(total_stats)
end

if ARGV.length != 1
  puts "Usage: ./scoreboard 'My Name'"
  exit
end
author = ARGV[0]

print "Collecting stats from cloned repos.."
total_stats = collect_stats(author, -> { print "." })
puts "\n\n"
print_all_stats(total_stats, top: 15)
