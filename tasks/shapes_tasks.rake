namespace :shapes do
  desc 'Sync extra files from shapes plugin'
  task :sync do
    system 'rsync -ruv vendor/plugins/shapes/db/migrate db'
    system 'rsync -ruv vendor/plugins/shapes/public .'
  end
end
