# load Rails.root.join('db', 'seeds', 'teams.rb')
p "team完了"
sleep(1)
load Rails.root.join('db', 'seeds', 'players.rb')
p "player完了"
sleep(1)
# load Rails.root.join('db', 'seeds', 'matches.rb')
p "match完了"