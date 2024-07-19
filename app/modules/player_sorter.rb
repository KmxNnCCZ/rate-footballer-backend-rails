module PlayerSorter
  def self.sort_players(players)
    position_priority = {
      "Goalkeeper" => 1,
      "Defence" => 2,
      "Defender" => 2,
      "Left-Back" => 3,
      "Centre-Back" => 4,
      "Right-Back" => 5,
      "Defensive Midfield" => 6,
      "Central Midfield" => 7,
      "Midfielder" => 7,
      "Midfield" => 7,
      "Attacking Midfield" => 8,
      "Left Winger" => 9,
      "Right Winger" => 9,
      "Offence" => 10,
      "Forward" => 10,
      "Centre-Forward" => 11,
    }

    # キー名を統一するための変換処理
    players.map! do |player|
      player[:shirt_number] ||= player.delete(:shirtNumber)
      player
    end

    # ポジション、背番号の順でソート(ポジション、背番号がnilの時は無限大を返す)
    sorted = players.sort_by do |player|
      [position_priority[player[:position]] || Float::INFINITY, player[:shirt_number].to_i || Float::INFINITY]
    end
    return sorted
  end
end