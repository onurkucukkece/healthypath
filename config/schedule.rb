# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
every 5.minutes, roles: [:app] do
  runner "DealersWorker.perform_async()"
end

# This is for Hertz forms
every 2.day, :at => '1:00 pm', roles: [:app] do
  command "curl -k 'https://hertz.istweb.biz/touring/mailer.php?token=oqo7xe5Ov2wPG4VOTpzq683hfIz7v7Kb'"
end

# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# every :day, :at => '12:20am', :roles => [:app] do