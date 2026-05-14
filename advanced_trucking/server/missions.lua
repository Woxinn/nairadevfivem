Missions = {}

local function resetKey(period)
  local t = os.date('*t')
  if period == 'daily' then
    return os.date('%Y-%m-%d')
  end
  -- weekly key: year-week
  return os.date('%Y-W%W')
end

local function ensureMissionRow(identifier, mission, period)
  local key = resetKey(period)
  local row = MySQL.single.await('SELECT * FROM advanced_trucking_missions WHERE identifier=? AND mission_id=? AND reset_period=?', {identifier, mission.id, key})
  if row then return row end
  MySQL.insert.await('INSERT INTO advanced_trucking_missions (identifier, mission_id, mission_type, progress, completed, claimed, reset_period) VALUES (?, ?, ?, 0, 0, 0, ?)', {identifier, mission.id, period, key})
  return MySQL.single.await('SELECT * FROM advanced_trucking_missions WHERE identifier=? AND mission_id=? AND reset_period=?', {identifier, mission.id, key})
end

function Missions.GetForPlayer(identifier)
  local out = { daily = {}, weekly = {} }

  for _, mission in pairs(Config.Missions.Daily or {}) do
    local row = ensureMissionRow(identifier, mission, 'daily')
    out.daily[#out.daily + 1] = {
      id = mission.id,
      label = mission.label,
      type = mission.type,
      amount = mission.amount,
      rewards = mission.rewards,
      progress = row.progress,
      completed = row.completed == 1,
      claimed = row.claimed == 1
    }
  end

  for _, mission in pairs(Config.Missions.Weekly or {}) do
    local row = ensureMissionRow(identifier, mission, 'weekly')
    out.weekly[#out.weekly + 1] = {
      id = mission.id,
      label = mission.label,
      type = mission.type,
      amount = mission.amount,
      rewards = mission.rewards,
      progress = row.progress,
      completed = row.completed == 1,
      claimed = row.claimed == 1
    }
  end

  return out
end

function Missions.ApplyDeliveryProgress(identifier)
  local missions = Missions.GetForPlayer(identifier)

  local function bump(list, period)
    for _, m in pairs(list) do
      if m.type == 'complete_deliveries' and not m.claimed then
        local newProgress = math.min(m.amount, (m.progress or 0) + 1)
        local completed = newProgress >= m.amount and 1 or 0
        MySQL.update.await('UPDATE advanced_trucking_missions SET progress=?, completed=? WHERE identifier=? AND mission_id=? AND reset_period=?', {
          newProgress, completed, identifier, m.id, resetKey(period)
        })
      end
    end
  end

  bump(missions.daily, 'daily')
  bump(missions.weekly, 'weekly')
end

function Missions.Claim(src, identifier, missionId, period)
  local key = resetKey(period)
  local row = MySQL.single.await('SELECT * FROM advanced_trucking_missions WHERE identifier=? AND mission_id=? AND reset_period=?', {identifier, missionId, key})
  if not row then return false, 'Mission not found' end
  if row.completed ~= 1 then return false, 'Mission not completed' end
  if row.claimed == 1 then return false, 'Already claimed' end

  local cfgList = period == 'daily' and (Config.Missions.Daily or {}) or (Config.Missions.Weekly or {})
  local cfg
  for _, m in pairs(cfgList) do if m.id == missionId then cfg = m break end end
  if not cfg then return false, 'Mission config missing' end

  if cfg.rewards.money and cfg.rewards.money > 0 then Framework.AddMoney(src, cfg.rewards.money) end
  if cfg.rewards.xp and cfg.rewards.xp > 0 then
    local profile = DB.FetchProfile(identifier, Framework.GetName(src))
    profile.xp = (profile.xp or 0) + cfg.rewards.xp
    profile.level = Progression.GetLevelFromXP(profile.xp)
    DB.UpdateProfile(identifier, profile)
  end

  if cfg.rewards.reputation and cfg.rewards.reputation > 0 then
    local profile = DB.FetchProfile(identifier, Framework.GetName(src))
    Reputation.Apply(profile, cfg.rewards.reputation)
    DB.UpdateProfile(identifier, profile)
  end

  MySQL.update.await('UPDATE advanced_trucking_missions SET claimed=1 WHERE identifier=? AND mission_id=? AND reset_period=?', {identifier, missionId, key})
  return true
end
