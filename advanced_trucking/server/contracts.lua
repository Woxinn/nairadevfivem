Contracts = {
  PlayerBoards = {},
  LastRefresh = {}
}

local function cloneTable(t)
  local out = {}
  for k,v in pairs(t or {}) do out[k]=v end
  return out
end

local function canSeeContract(profile, contract)
  local hasLevel = (profile.level or 1) >= (contract.requiredLevel or 1)
  local locked = not hasLevel
  return (not locked or Config.Contracts.ShowLockedContracts), locked
end

local function generateDynamic(profile)
  local generated = {}
  local maxVisible = Config.Contracts.MaxVisibleContracts or 8
  local staticPool = Config.StaticContracts or {}

  for i=1, maxVisible do
    local base = staticPool[((i - 1) % #staticPool) + 1]
    local clone = cloneTable(base)
    clone.id = ('dyn_%s_%s_%s'):format(profile.level or 1, i, os.time())
    clone.basePayment = math.floor((base.basePayment or 1000) * (1.0 + ((profile.level or 1) * 0.03)))
    clone.distance = math.max(1.0, (base.distance or 4.0) + (i * 0.3))
    generated[#generated+1] = clone
  end

  return generated
end

function Contracts.RefreshBoard(src, profile)
  local identifier = Framework.GetIdentifier(src)
  local mode = Config.ContractMode or 'static'
  local pool = {}

  if mode == 'static' then
    pool = Config.StaticContracts
  elseif mode == 'dynamic' then
    pool = generateDynamic(profile)
  else -- mixed
    pool = {}
    for _, c in pairs(Config.StaticContracts) do pool[#pool+1] = c end
    for _, c in pairs(generateDynamic(profile)) do pool[#pool+1] = c end
  end

  local visible = {}
  for _, contract in pairs(pool) do
    local show, locked = canSeeContract(profile, contract)
    if show then
      local copy = cloneTable(contract)
      copy.locked = locked
      visible[#visible+1] = copy
    end
  end

  Contracts.PlayerBoards[identifier] = visible
  Contracts.LastRefresh[identifier] = os.time()
  return visible
end

function Contracts.GetVisible(src, profile)
  local identifier = Framework.GetIdentifier(src)
  local refreshMin = Config.Contracts.RefreshMinutes or 15
  local last = Contracts.LastRefresh[identifier] or 0
  if not Contracts.PlayerBoards[identifier] or (os.time() - last) > (refreshMin * 60) then
    return Contracts.RefreshBoard(src, profile)
  end
  return Contracts.PlayerBoards[identifier]
end

function Contracts.GetById(src, id)
  local identifier = Framework.GetIdentifier(src)
  local board = Contracts.PlayerBoards[identifier] or {}
  for _,c in pairs(board) do
    if c.id == id then return c end
  end
  for _,c in pairs(Config.StaticContracts) do
    if c.id == id then return c end
  end
end
