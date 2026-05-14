Leaderboard = {
  cache = {},
  cacheAt = 0
}

local CategoryMap = {
  total_earnings = 'total_earnings',
  completed_deliveries = 'completed_deliveries',
  reputation = 'reputation',
  total_distance = 'total_distance',
  perfect_deliveries = 'perfect_deliveries',
  weekly_earnings = 'weekly_earnings'
}

local function fetchCategory(column)
  return MySQL.query.await(('SELECT name, %s AS value FROM advanced_trucking_profiles ORDER BY %s DESC LIMIT 25'):format(column, column)) or {}
end

function Leaderboard.Refresh(force)
  local now = os.time()
  if not force and (now - Leaderboard.cacheAt) < ((Config.Leaderboard.RefreshMinutes or 10) * 60) then
    return Leaderboard.cache
  end

  local out = {}
  for _, category in pairs(Config.Leaderboard.Categories or {}) do
    local col = CategoryMap[category]
    if col then
      out[category] = fetchCategory(col)
    end
  end

  Leaderboard.cache = out
  Leaderboard.cacheAt = now
  return out
end

function Leaderboard.Get(category)
  local data = Leaderboard.Refresh(false)
  if category and data[category] then return data[category] end
  return data
end
