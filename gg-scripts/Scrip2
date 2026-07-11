gg.require('8.0')
gg.setVisible(false)

-- =========================
-- متغیرهای سراسری
-- =========================
local myCharAddr = nil
local enemyAddrs = {}       -- {addr, type, name, enabled, boneMode, hOffset, vOffset, teamID, invalidCount}
local yawAddr = nil
local pitchAddr = nil

-- متغیرهای دکمه شلیک
local fireButtonAddr = nil
local fireToggleActive = true
local lastFireState = 0

-- متغیرهای سیستم Frame-Aligned Prediction
local currentTarget = nil
local targetPosHistory = {}
local lastFrameTime = 0
local frameTimeSum = 0
local frameCount = 0
local avgFrameTime = 0.016

local POS_HISTORY_SIZE = 3

-- آفست‌ها
local OFF_X = 448
local OFF_Y = 452
local OFF_Z = 456
local OFF_TYPE_PTR = 424
local OFF_TYPE_VAL = 168
local OFF_FIRE_BUTTON = 432
local OFF_TEAM_PTR = 568
local OFF_TEAM_VAL = 20

-- =========================
-- تنظیمات کاراکترها (با پشتیبانی از بازه‌ها)
-- =========================
local TYPE_AIM_HEIGHT = { [0] = 1.6 }
local TYPE_NAMES = { [0] = "Unknown" }
local TYPE_HORIZONTAL_OFFSET = { [0] = 0.0 }
local TYPE_VERTICAL_OFFSET = { [0] = 0.0 }

local TYPE_RANGES = {
    {start = 30012001, stop = 30012011, height = 0, name = "Victor",   hOffset = 0.0, vOffset = 0.0},
    {start = 20012001, stop = 20012015, height = 0, name = "Mark",     hOffset = 0.0, vOffset = 0.0},
    {start = 100012001, stop = 100012010, height = 0, name = "ono",    hOffset = 0.0, vOffset = 0.0},
    {start = 110012001, stop = 110012010, height = 0, name = "zero",   hOffset = 0.0, vOffset = 0.0},
    {start = 120012001, stop = 120012010, height = 0, name = "fade",   hOffset = 0.0, vOffset = 0.0},
    {start = 190012001, stop = 190012010, height = 0, name = "ruby",   hOffset = 0.0, vOffset = 0.0},
    {start = 200012001, stop = 200012010, height = 0, name = "jabaly", hOffset = 0.0, vOffset = 0.0},
    {start = 280012001, stop = 280012010, height = 0, name = "fort",   hOffset = 0.0, vOffset = 0.0},
    {start = 300012001, stop = 300012010, height = 0, name = "tigris", hOffset = 0.0, vOffset = 0.0},
    {start = 40012001,  stop = 40012040,  height = 0, name = "osas",   hOffset = 0.0, vOffset = 0.0},
    {start = 70012001,  stop = 70012020,  height = 0, name = "skadi",  hOffset = 0.0, vOffset = 0.0},
    {start = 80012001,  stop = 80012020,  height = 0, name = "cristina", hOffset = 0.0, vOffset = 0.0},
    {start = 150012001, stop = 150012020, height = 0, name = "hunter", hOffset = 0.0, vOffset = 0.0},
    {start = 170012001, stop = 170012020, height = 0, name = "hualing", hOffset = 0.0, vOffset = 0.0},
    {start = 290012001, stop = 290012010, height = 0, name = "daimon", hOffset = 0.0, vOffset = 0.0},
    {start = 360012001, stop = 360012020, height = 0, name = "gloria", hOffset = 0.0, vOffset = 0.0},
    {start = 50012001,  stop = 50012020,  height = 0, name = "judex",  hOffset = 0.0, vOffset = 0.0},
    {start = 130012001, stop = 130012020, height = 0, name = "lacia",  hOffset = 0.0, vOffset = 0.0},
    {start = 210012001, stop = 210012020, height = 0, name = "gatlin", hOffset = 0.0, vOffset = 0.0},
    {start = 60012001,  stop = 60012020,  height = 0, name = "kazama", hOffset = 0.0, vOffset = 0.0},
    {start = 180012001, stop = 180012020, height = 0, name = "yaa",    hOffset = 0.0, vOffset = 0.0},
    {start = 220012001, stop = 220012020, height = 0, name = "diggy",  hOffset = 0.0, vOffset = 0.0},
    {start = 240012001, stop = 240012020, height = 0, name = "shell",  hOffset = 0.0, vOffset = 0.0},
    {start = 250012001, stop = 250012020, height = 0, name = "Vincent", hOffset = 0.0, vOffset = 0.0},
    {start = 340012001, stop = 340012020, height = 0, name = "johanny", hOffset = 0.0, vOffset = 0.0},
    {start = 90012001,  stop = 90012020,  height = 0, name = "neon",   hOffset = 0.0, vOffset = 0.0},
    {start = 140012001, stop = 140012020, height = 0, name = "labula", hOffset = 0.0, vOffset = 0.0},
    {start = 160012001, stop = 160012020, height = 0, name = "iris",   hOffset = 0.0, vOffset = 0.0},
    {start = 260012001, stop = 260012020, height = 0, name = "shindry", hOffset = 0.0, vOffset = 0.0},
    {start = 270012001, stop = 270012020, height = 0, name = "chmist", hOffset = 0.0, vOffset = 0.0},
    {start = 10012001,  stop = 10012020,  height = 0, name = "Mark",   hOffset = 0.0, vOffset = 0.0},
}

-- =========================
-- تنظیمات اصلی و پیشرفته
-- =========================
local CONFIG = {
    fov            = 30.0,
    smooth         = 0.00,
    maxDistance    = 9999.0,
    minDistance    = 0.0,

    invertPitch    = true,
    invertYaw      = false,

    yawOffset      = 0.0,
    pitchOffset    = 0.0,

    humanRandom    = 0.0,
    showDebug      = false,

    targetSelectMode   = 1,
    boneModeGlobal = 10,
    customAimHeight = 1.6,

    dynamicFOV     = false,
    dynamicFOVMin  = 10,
    dynamicFOVMax  = 60,
    dynamicFOVDist = 40.0,
    
    predictionEnabled = true,
    predictionTime    = 0.15,
    autoPrediction    = true,
    maxPredictionTime = 0.05,
    minPredictionTime = 0.01,
    velocitySmoothing = 0.3,
    useAcceleration   = false,
    extrapolateMode   = 1,
    showPredictionDebug = false,
    
    activationRanges = {
        [1] = 9999.0,
        [2] = 9999.0,
        [3] = 9999.0,
        [4] = 9999.0,
    },
    
    hybridWeights = {
        distance = 0.7,
        angle    = 0.3,
        fov      = 0.5,
    },
    
    advancedFilters = {
        minHealth = 0,
        requireVisible = false,
        prioritizeLowHealth = false,
    },
    
    aimOnlyInFOV = true,   -- گزینه جدید: فقط در صورت قرارگیری هدف در FOV شلیک کند
}

local TARGET_SELECT_MODE = {
    CLOSEST_TO_FOV   = 1,
    CLOSEST_OVERALL  = 2,
    HYBRID           = 3,
    DYNAMIC          = 4,
}

local BONE_MODE = {
    AUTO   = 10,
    HEAD   = 2,
    CHEST  = 3,
    CUSTOM = 0,
}

local isAimbotActive = false
local wallActive = false

-- =========================
-- متغیرهای به‌روزرسانی اضطراری
-- =========================
local needEnemyUpdate = false          -- درخواست به‌روزرسانی بر اساس مختصات نامعتبر
local ENEMY_UPDATE_COOLDOWN = 0.5     -- حداقل فاصله بین دو به‌روزرسانی اضطراری (ثانیه)
local lastEmergencyUpdateTime = 0

-- =========================
-- ابزارهای کمکی
-- =========================
local function safeGet(vals, idx)
    return vals and vals[idx] and vals[idx].value
end

local function clamp(v, min, max)
    if v < min then return min end
    if v > max then return max end
    return v
end

local function normalizeAngle(angle)
    while angle > 180 do angle = angle - 360 end
    while angle < -180 do angle = angle + 360 end
    return angle
end

-- =========================
-- مدیریت بازه کاراکترها
-- =========================
local function initCharacterRanges()
    TYPE_AIM_HEIGHT = {[0] = 1.6}
    TYPE_NAMES = {[0] = "Unknown"}
    TYPE_HORIZONTAL_OFFSET = {[0] = 0.0}
    TYPE_VERTICAL_OFFSET = {[0] = 0.0}
    
    for _, range in ipairs(TYPE_RANGES) do
        for id = range.start, range.stop do
            TYPE_AIM_HEIGHT[id] = range.height or 1.6
            TYPE_NAMES[id] = range.name or ("نوع " .. id)
            TYPE_HORIZONTAL_OFFSET[id] = range.hOffset or 0.0
            TYPE_VERTICAL_OFFSET[id] = range.vOffset or 0.0
        end
    end
end

initCharacterRanges()

local function getCharacterHorizontalOffset(enemyType)
    return TYPE_HORIZONTAL_OFFSET[enemyType] or 0.0
end

local function getCharacterVerticalOffset(enemyType)
    return TYPE_VERTICAL_OFFSET[enemyType] or 0.0
end

local function getTeamID(charAddr)
    if not charAddr or charAddr == 0 then return nil end
    
    local teamPtr = safeGet(gg.getValues({
        {address = charAddr + OFF_TEAM_PTR, flags = gg.TYPE_QWORD}
    }), 1)
    if not teamPtr or teamPtr == 0 then return nil end

    return safeGet(gg.getValues({
        {address = teamPtr + OFF_TEAM_VAL, flags = gg.TYPE_DWORD}
    }), 1)
end

local function getCharacterType(charAddr)
    if not charAddr or charAddr == 0 then return 0 end
    local typePtr = safeGet(gg.getValues({{address = charAddr + OFF_TYPE_PTR, flags = gg.TYPE_QWORD}}), 1)
    if not typePtr or typePtr == 0 then return 0 end
    return safeGet(gg.getValues({{address = typePtr + OFF_TYPE_VAL, flags = gg.TYPE_DWORD}}), 1) or 0
end

-- =========================
-- محاسبات فاصله و زاویه
-- =========================
local function getDistanceSqr(px, py, pz, ex, ey, ez)
    local dx = ex - px
    local dy = ey - py
    local dz = ez - pz
    return dx*dx + dy*dy + dz*dz
end

local function getDistance(px, py, pz, ex, ey, ez)
    return math.sqrt(getDistanceSqr(px, py, pz, ex, ey, ez))
end

local function getAngularDistance(cy, cp, ty, tp)
    local yd = math.abs(ty - cy)
    if yd > 180 then yd = 360 - yd end
    local pd = math.abs(tp - cp)
    return math.sqrt(yd*yd + pd*pd)
end

local function getBoneAimHeight(enemy, baseY)
    local mode = enemy.boneMode or CONFIG.boneModeGlobal

    if mode == BONE_MODE.HEAD then
        return 1.8
    elseif mode == BONE_MODE.CHEST then
        return 1.2
    elseif mode == BONE_MODE.CUSTOM then
        return CONFIG.customAimHeight
    else
        return TYPE_AIM_HEIGHT[enemy.type] or 1.6
    end
end

local function calculateAngles(px, py, pz, ex, ey, ez, aimH, enemyType)
    local dx = ex - px
    local dz = ez - pz
    local dy = (ey + aimH) - py

    if CONFIG.invertYaw then dx = -dx end

    local yaw = math.deg(math.atan2(dx, dz))
    if yaw < 0 then yaw = yaw + 360 end

    local horizontal = math.sqrt(dx*dx + dz*dz)
    if horizontal < 0.01 then horizontal = 0.01 end

    local pitch = math.deg(math.atan2(dy, horizontal))
    pitch = clamp(pitch, -89.9, 89.9)

    if CONFIG.invertPitch then pitch = -pitch end

    yaw = yaw + CONFIG.yawOffset
    pitch = pitch + CONFIG.pitchOffset
    
    local charHOffset = getCharacterHorizontalOffset(enemyType)
    local charVOffset = getCharacterVerticalOffset(enemyType)
    
    yaw = yaw + charHOffset
    pitch = pitch + charVOffset

    return yaw, pitch
end

local function applySmoothing(cur, target, smooth)
    if smooth <= 0 then return target end
    local delta = target - cur
    if math.abs(delta) > 180 then
        if delta > 0 then delta = delta - 360 else delta = delta + 360 end
    end
    return cur + delta * clamp(smooth, 0.0, 1.0)
end

local function applyHumanRandom(angle)
    if CONFIG.humanRandom <= 0 then return angle end
    return angle + (math.random() * 2 - 1) * CONFIG.humanRandom
end

local function getEffectiveFOV(distSqr)
    if not CONFIG.dynamicFOV then return CONFIG.fov end
    local d = math.sqrt(distSqr)
    local t = clamp(d / CONFIG.dynamicFOVDist, 0.0, 1.0)
    return CONFIG.dynamicFOVMin + (CONFIG.dynamicFOVMax - CONFIG.dynamicFOVMin) * t
end

-- =========================
-- سیستم Frame-Aligned Prediction
-- =========================
local function updateFrameTime()
    local currentTime = os.clock()
    if lastFrameTime > 0 then
        local delta = currentTime - lastFrameTime
        frameTimeSum = frameTimeSum + delta
        frameCount = frameCount + 1
        if frameCount >= 10 then
            avgFrameTime = frameTimeSum / frameCount
            frameTimeSum = 0; frameCount = 0
            avgFrameTime = clamp(avgFrameTime, 0.005, 0.1)
        end
    end
    lastFrameTime = currentTime
    return avgFrameTime
end

local function getPredictionTime()
    if not CONFIG.autoPrediction then return CONFIG.predictionTime end
    return clamp(avgFrameTime * 2.0, CONFIG.minPredictionTime, CONFIG.maxPredictionTime)
end

local function addPositionToHistory(addr, x, y, z)
    if not targetPosHistory[addr] then targetPosHistory[addr] = {} end
    local history = targetPosHistory[addr]
    table.insert(history, 1, {x = x, y = y, z = z, time = os.clock()})
    while #history > POS_HISTORY_SIZE do table.remove(history) end
end

local function calculateVelocity(history)
    if not history or #history < 2 then return 0,0,0 end
    local newest, oldest = history[1], history[#history]
    local dt = newest.time - oldest.time
    if dt <= 0 then return 0,0,0 end
    local vx = (newest.x - oldest.x) / dt
    local vy = (newest.y - oldest.y) / dt
    local vz = (newest.z - oldest.z) / dt
    if CONFIG.velocitySmoothing > 0 then
        if history.avgVx then
            vx = history.avgVx * (1 - CONFIG.velocitySmoothing) + vx * CONFIG.velocitySmoothing
            vy = history.avgVy * (1 - CONFIG.velocitySmoothing) + vy * CONFIG.velocitySmoothing
            vz = history.avgVz * (1 - CONFIG.velocitySmoothing) + vz * CONFIG.velocitySmoothing
        end
        history.avgVx, history.avgVy, history.avgVz = vx, vy, vz
    end
    return vx, vy, vz
end

local function predictPosition(history, predictionTime)
    if not history or #history < 2 then return nil,nil,nil end
    local cur = history[1]
    local vx, vy, vz = calculateVelocity(history)
    return cur.x + vx * predictionTime, cur.y + vy * predictionTime, cur.z + vz * predictionTime
end

-- =========================
-- اسکن کامل کاراکترها (فقط دشمن‌ها)
-- =========================
local function scanCharacters()
    gg.clearResults()
    gg.searchNumber("0.82352942228", gg.TYPE_FLOAT)
    local results = gg.getResults(5000)
    if not results or #results == 0 then
        gg.alert("❌ ساختار کاراکتر پیدا نشد!")
        return false
    end

    local validBases = {}
    for i, v in ipairs(results) do
        local checkAddr = v.address + 16
        local checkVal = safeGet(gg.getValues({{address = checkAddr, flags = gg.TYPE_FLOAT}}), 1)
        if checkVal and math.abs(checkVal - 0.53333336115) < 0.000001 then
            table.insert(validBases, v.address)
        end
    end
    if #validBases == 0 then return false end

    for _, baseAddr in ipairs(validBases) do
        local p1Val = safeGet(gg.getValues({{address = baseAddr + 40, flags = gg.TYPE_QWORD}}), 1)
        if not p1Val or p1Val < 0x6000000000 then goto continue end

        myCharAddr = safeGet(gg.getValues({{address = p1Val + 136, flags = gg.TYPE_QWORD}}), 1)

        local p2Val = safeGet(gg.getValues({{address = p1Val + 208, flags = gg.TYPE_QWORD}}), 1)
        if not p2Val or p2Val < 0x6000000000 then goto continue end

        local p3Val = safeGet(gg.getValues({{address = p2Val + 16, flags = gg.TYPE_QWORD}}), 1)
        if not p3Val or p3Val < 0x6000000000 then goto continue end

        local arrayBase = p3Val + 24
        enemyAddrs = {}
        targetPosHistory = {}
        currentTarget = nil

        for j = 0, 60 do
            local charPtr = safeGet(gg.getValues({{address = arrayBase + (j * 8), flags = gg.TYPE_QWORD}}), 1)
            if not charPtr or charPtr == 0 then break end
            if charPtr == myCharAddr then goto next end

            local teamID = getTeamID(charPtr)
            if teamID == 0 then
                local typeVal = getCharacterType(charPtr)
                local charName = TYPE_NAMES[typeVal] or ("نوع " .. typeVal)
                table.insert(enemyAddrs, {
                    addr     = charPtr,
                    type     = typeVal,
                    name     = charName,
                    enabled  = true,
                    boneMode = BONE_MODE.AUTO,
                    hOffset  = getCharacterHorizontalOffset(typeVal) or 0.0,
                    vOffset  = getCharacterVerticalOffset(typeVal) or 0.0,
                    teamID   = teamID,
                    invalidCount = 0,
                })
            end
            ::next::
        end

        if myCharAddr and #enemyAddrs > 0 then
            gg.toast("✅ " .. #enemyAddrs .. " دشمن پیدا شد (فقط دشمن‌ها)")
            return true
        end
        ::continue::
    end
    return false
end

-- =========================
-- به‌روزرسانی سریع دشمنان + آدرس‌های وابسته (در صورت تغییر کاراکتر)
-- =========================
local function quickEnemyUpdate()
    if not myCharAddr then
        if scanCharacters() then
            scanCamera()
            scanFireButton()
            gg.toast("🔄 کاراکتر خودکار جدید یافت شد و آدرس‌ها به‌روزرسانی شد")
        end
        return
    end

    gg.clearResults()
    gg.searchNumber("0.82352942228", gg.TYPE_FLOAT)
    local results = gg.getResults(5000)
    if not results or #results == 0 then return end

    local validBases = {}
    for i, v in ipairs(results) do
        local checkAddr = v.address + 16
        local checkVal = safeGet(gg.getValues({{address = checkAddr, flags = gg.TYPE_FLOAT}}), 1)
        if checkVal and math.abs(checkVal - 0.53333336115) < 0.000001 then
            table.insert(validBases, v.address)
        end
    end

    local arrayBase = nil
    for _, baseAddr in ipairs(validBases) do
        local p1Val = safeGet(gg.getValues({{address = baseAddr + 40, flags = gg.TYPE_QWORD}}), 1)
        if p1Val and p1Val >= 0x6000000000 then
            local candidate = safeGet(gg.getValues({{address = p1Val + 136, flags = gg.TYPE_QWORD}}), 1)
            if candidate and candidate == myCharAddr then
                local p2Val = safeGet(gg.getValues({{address = p1Val + 208, flags = gg.TYPE_QWORD}}), 1)
                if p2Val and p2Val >= 0x6000000000 then
                    local p3Val = safeGet(gg.getValues({{address = p2Val + 16, flags = gg.TYPE_QWORD}}), 1)
                    if p3Val and p3Val >= 0x6000000000 then
                        arrayBase = p3Val + 24
                        break
                    end
                end
            end
        end
    end

    if not arrayBase then
        if scanCharacters() then
            scanCamera()
            scanFireButton()
            gg.toast("🔄 کاراکتر خودکار تغییر کرد، آدرس‌ها به‌روزرسانی شد")
        end
        return
    end

    local currentEnemyAddrs = {}
    for j = 0, 60 do
        local charPtr = safeGet(gg.getValues({{address = arrayBase + (j * 8), flags = gg.TYPE_QWORD}}), 1)
        if not charPtr or charPtr == 0 then break end
        if charPtr ~= myCharAddr then
            local teamID = getTeamID(charPtr)
            if teamID == 0 then
                currentEnemyAddrs[charPtr] = true

                local found = false
                for k, e in ipairs(enemyAddrs) do
                    if e.addr == charPtr then
                        found = true
                        e.invalidCount = 0
                        break
                    end
                end
                if not found then
                    local typeVal = getCharacterType(charPtr)
                    local charName = TYPE_NAMES[typeVal] or ("نوع " .. typeVal)
                    table.insert(enemyAddrs, {
                        addr     = charPtr,
                        type     = typeVal,
                        name     = charName,
                        enabled  = true,
                        boneMode = BONE_MODE.AUTO,
                        hOffset  = getCharacterHorizontalOffset(typeVal) or 0.0,
                        vOffset  = getCharacterVerticalOffset(typeVal) or 0.0,
                        teamID   = teamID,
                        invalidCount = 0,
                    })
                    gg.toast("➕ دشمن جدید: " .. charName)
                end
            end
        end
    end

    local i = 1
    while i <= #enemyAddrs do
        local e = enemyAddrs[i]
        if not currentEnemyAddrs[e.addr] then
            table.remove(enemyAddrs, i)
            targetPosHistory[e.addr] = nil
            gg.toast("➖ دشمن حذف شد: " .. e.name)
        else
            i = i + 1
        end
    end
end

-- =========================
-- اسکن دکمه شلیک و دوربین
-- =========================
local function scanFireButton()
    if not myCharAddr then gg.toast("⚠️ ابتدا کاراکتر خود را اسکن کنید"); return false end
    fireButtonAddr = myCharAddr + OFF_FIRE_BUTTON
    local testVal = safeGet(gg.getValues({{address = fireButtonAddr, flags = gg.TYPE_DWORD}}), 1)
    if testVal ~= nil then lastFireState = testVal; gg.toast("✅ آدرس دکمه شلیک پیدا شد"); return true end
    gg.toast("❌ نتوانستم دکمه شلیک را پیدا کنم"); fireButtonAddr = nil; return false
end

local function scanCamera()
    gg.clearResults()
    gg.searchNumber("-80", gg.TYPE_FLOAT)
    local results = gg.getResults(5000)
    if not results then return false end
    for i, v in ipairs(results) do
        local base = v.address
        local check1 = safeGet(gg.getValues({{address = base + 28, flags = gg.TYPE_FLOAT}}), 1)
        if check1 and check1 == -80 then
            local check2 = safeGet(gg.getValues({{address = base + 36, flags = gg.TYPE_FLOAT}}), 1)
            if check2 and check2 == -80 then
                pitchAddr = base; yawAddr = base - 4
                gg.toast("✅ آدرس دوربین پیدا شد"); return true
            end
        end
    end
    return false
end

-- =========================
-- توابع انتخاب هدف (با تشخیص مختصات نامعتبر)
-- =========================
local function readEnemyCoordinates(e)
    local evals = gg.getValues({
        {address = e.addr + OFF_X, flags = gg.TYPE_FLOAT},
        {address = e.addr + OFF_Y, flags = gg.TYPE_FLOAT},
        {address = e.addr + OFF_Z, flags = gg.TYPE_FLOAT}
    })
    local ex, ey, ez = evals[1].value or 0, evals[2].value or 0, evals[3].value or 0
    if ex == 0 and ey == 0 and ez == 0 then
        e.invalidCount = (e.invalidCount or 0) + 1
        if e.invalidCount >= 5 then
            needEnemyUpdate = true
        end
        return nil, nil, nil
    else
        e.invalidCount = 0
        return ex, ey, ez
    end
end

local function selectTargetClosestToFOV(px, py, pz, currentYaw, currentPitch)
    local bestYaw, bestPitch, bestScore, bestIndex, bestPredicted = nil, nil, 1e18, nil, false
    local maxRange = CONFIG.activationRanges[CONFIG.targetSelectMode] or 9999.0
    for i, e in ipairs(enemyAddrs) do
        if e and e.enabled then
            local ex, ey, ez = readEnemyCoordinates(e)
            if ex then
                local distSqr = getDistanceSqr(px, py, pz, ex, ey, ez)
                local dist = math.sqrt(distSqr)
                if dist <= maxRange then
                    addPositionToHistory(e.addr, ex, ey, ez)
                    local targetX, targetY, targetZ = ex, ey, ez
                    local usingPrediction = false
                    if CONFIG.predictionEnabled then
                        local predX, predY, predZ = predictPosition(targetPosHistory[e.addr], getPredictionTime())
                        if predX then targetX, targetY, targetZ = predX, predY, predZ; usingPrediction = true end
                    end
                    local aimH = getBoneAimHeight(e, targetY)
                    local yaw, pitch = calculateAngles(px, py, pz, targetX, targetY, targetZ, aimH, e.type)
                    local angleDist = getAngularDistance(currentYaw, currentPitch, yaw, pitch)
                    local effectiveFOV = getEffectiveFOV(distSqr)
                    if angleDist <= effectiveFOV then
                        local score = dist * CONFIG.hybridWeights.distance + angleDist * CONFIG.hybridWeights.angle
                        if usingPrediction then score = score * 0.7 end
                        if score < bestScore then
                            bestScore = score; bestYaw = yaw; bestPitch = pitch; bestIndex = i; bestPredicted = usingPrediction
                        end
                    end
                end
            end
        end
    end
    return bestYaw, bestPitch, bestIndex, bestPredicted
end

local function selectTargetClosestOverall(px, py, pz, currentYaw, currentPitch)
    local bestYaw, bestPitch, bestDist, bestIndex, bestPredicted = nil, nil, 1e18, nil, false
    local maxRange = CONFIG.activationRanges[CONFIG.targetSelectMode] or 9999.0
    for i, e in ipairs(enemyAddrs) do
        if e and e.enabled then
            local ex, ey, ez = readEnemyCoordinates(e)
            if ex then
                local distSqr = getDistanceSqr(px, py, pz, ex, ey, ez)
                local dist = math.sqrt(distSqr)
                if dist <= maxRange then
                    addPositionToHistory(e.addr, ex, ey, ez)
                    local targetX, targetY, targetZ = ex, ey, ez
                    local usingPrediction = false
                    if CONFIG.predictionEnabled then
                        local predX, predY, predZ = predictPosition(targetPosHistory[e.addr], getPredictionTime())
                        if predX then targetX, targetY, targetZ = predX, predY, predZ; usingPrediction = true end
                    end
                    local aimH = getBoneAimHeight(e, targetY)
                    local yaw, pitch = calculateAngles(px, py, pz, targetX, targetY, targetZ, aimH, e.type)
                    
                    -- [افزوده‌شده] بررسی FOV در صورت فعال بودن گزینه
                    if CONFIG.aimOnlyInFOV then
                        local angleDist = getAngularDistance(currentYaw, currentPitch, yaw, pitch)
                        local effectiveFOV = getEffectiveFOV(distSqr)
                        if angleDist > effectiveFOV then
                            goto skip
                        end
                    end
                    
                    local targetDistSqr = getDistanceSqr(px, py, pz, targetX, targetY, targetZ)
                    local targetDist = math.sqrt(targetDistSqr)
                    if targetDist < bestDist then
                        bestDist = targetDist; bestYaw = yaw; bestPitch = pitch; bestIndex = i; bestPredicted = usingPrediction
                    end
                    ::skip::
                end
            end
        end
    end
    return bestYaw, bestPitch, bestIndex, bestPredicted
end

local function selectTargetHybrid(px, py, pz, currentYaw, currentPitch)
    local bestYaw, bestPitch, bestScore, bestIndex, bestPredicted = nil, nil, 1e18, nil, false
    local maxRange = CONFIG.activationRanges[CONFIG.targetSelectMode] or 9999.0
    for i, e in ipairs(enemyAddrs) do
        if e and e.enabled then
            local ex, ey, ez = readEnemyCoordinates(e)
            if ex then
                local distSqr = getDistanceSqr(px, py, pz, ex, ey, ez)
                local dist = math.sqrt(distSqr)
                if dist <= maxRange then
                    addPositionToHistory(e.addr, ex, ey, ez)
                    local targetX, targetY, targetZ = ex, ey, ez
                    local usingPrediction = false
                    if CONFIG.predictionEnabled then
                        local predX, predY, predZ = predictPosition(targetPosHistory[e.addr], getPredictionTime())
                        if predX then targetX, targetY, targetZ = predX, predY, predZ; usingPrediction = true end
                    end
                    local aimH = getBoneAimHeight(e, targetY)
                    local yaw, pitch = calculateAngles(px, py, pz, targetX, targetY, targetZ, aimH, e.type)
                    local angleDist = getAngularDistance(currentYaw, currentPitch, yaw, pitch)
                    local effectiveFOV = getEffectiveFOV(distSqr)
                    local score = dist * CONFIG.hybridWeights.distance + angleDist * CONFIG.hybridWeights.angle
                    if usingPrediction then score = score * 0.8 end
                    if score < bestScore then
                        bestScore = score; bestYaw = yaw; bestPitch = pitch; bestIndex = i; bestPredicted = usingPrediction
                    end
                end
            end
        end
    end
    return bestYaw, bestPitch, bestIndex, bestPredicted
end

local function selectTargetDynamic(px, py, pz, currentYaw, currentPitch)
    return selectTargetHybrid(px, py, pz, currentYaw, currentPitch)
end

local function selectBestTarget(px, py, pz, currentYaw, currentPitch)
    local mode = CONFIG.targetSelectMode
    if mode == TARGET_SELECT_MODE.CLOSEST_TO_FOV then
        return selectTargetClosestToFOV(px, py, pz, currentYaw, currentPitch)
    elseif mode == TARGET_SELECT_MODE.CLOSEST_OVERALL then
        return selectTargetClosestOverall(px, py, pz, currentYaw, currentPitch)
    elseif mode == TARGET_SELECT_MODE.HYBRID then
        return selectTargetHybrid(px, py, pz, currentYaw, currentPitch)
    elseif mode == TARGET_SELECT_MODE.DYNAMIC then
        return selectTargetDynamic(px, py, pz, currentYaw, currentPitch)
    else
        return selectTargetClosestToFOV(px, py, pz, currentYaw, currentPitch)
    end
end

-- =========================
-- AIMBOT
-- =========================
function aimbotLoop()
    updateFrameTime()
    if not isAimbotActive or not myCharAddr or not yawAddr or not pitchAddr then return end
    
    local firePressed = false
    if fireToggleActive and fireButtonAddr then
        local fireState = safeGet(gg.getValues({{address = fireButtonAddr, flags = gg.TYPE_DWORD}}), 1)
        if fireState ~= nil then firePressed = (fireState == 0); lastFireState = fireState end
    else
        firePressed = true
    end
    if not firePressed then currentTarget = nil; return end
    
    local vals = gg.getValues({
        {address = myCharAddr + OFF_X, flags = gg.TYPE_FLOAT},
        {address = myCharAddr + OFF_Y, flags = gg.TYPE_FLOAT},
        {address = myCharAddr + OFF_Z, flags = gg.TYPE_FLOAT},
        {address = yawAddr, flags = gg.TYPE_FLOAT},
        {address = pitchAddr, flags = gg.TYPE_FLOAT},
    })
    local px, py, pz = vals[1].value or 0, vals[2].value or 0, vals[3].value or 0
    local currentYaw, currentPitch = vals[4].value or 0, vals[5].value or 0
    
    local bestYaw, bestPitch, targetIndex, usingPrediction = selectBestTarget(px, py, pz, currentYaw, currentPitch)
    if not bestYaw then currentTarget = nil; return end
    
    local targetEnemy = enemyAddrs[targetIndex]
    currentTarget = {index = targetIndex, addr = targetEnemy.addr, name = targetEnemy.name, predicted = usingPrediction}
    
    local finalYaw = applySmoothing(currentYaw, bestYaw, CONFIG.smooth)
    local finalPitch = applySmoothing(currentPitch, bestPitch, CONFIG.smooth)
    finalYaw = applyHumanRandom(finalYaw); finalPitch = applyHumanRandom(finalPitch)
    
    gg.setValues({
        {address = yawAddr, flags = gg.TYPE_FLOAT, value = finalYaw},
        {address = pitchAddr, flags = gg.TYPE_FLOAT, value = finalPitch},
    })
    
    if CONFIG.showPredictionDebug then
        local modeName = "Unknown"
        if CONFIG.targetSelectMode == TARGET_SELECT_MODE.CLOSEST_TO_FOV then modeName = "Closest to FOV"
        elseif CONFIG.targetSelectMode == TARGET_SELECT_MODE.CLOSEST_OVERALL then modeName = "Closest Overall"
        elseif CONFIG.targetSelectMode == TARGET_SELECT_MODE.HYBRID then modeName = "Hybrid"
        elseif CONFIG.targetSelectMode == TARGET_SELECT_MODE.DYNAMIC then modeName = "Dynamic" end
        local debugMsg = string.format("🎯 %s (%s)%s\nRange: %.1fm\nFrame: %.1fms",
            targetEnemy.name, modeName, usingPrediction and " [Pred]" or "",
            CONFIG.activationRanges[CONFIG.targetSelectMode] or 0, avgFrameTime * 1000)
        gg.toast(debugMsg, false)
    end
end

-- =========================
-- WallHack (فقط دشمنان)
-- =========================
local function applyWallHack()
    if not wallActive or #enemyAddrs == 0 then return end
    local t = {}
    for i = 1, #enemyAddrs do
        local e = enemyAddrs[i]
        t[#t+1] = {address = e.addr + 392, flags = gg.TYPE_DWORD, value = 0}
        t[#t+1] = {address = e.addr + 480, flags = gg.TYPE_DWORD, value = 65536}
    end
    gg.setValues(t)
end

-- =========================
-- منوها (کامل)
-- =========================
local function menuTargetSelectSettings()
    local modeNames = {
        [TARGET_SELECT_MODE.CLOSEST_TO_FOV] = "نزدیک‌ترین به FOV",
        [TARGET_SELECT_MODE.CLOSEST_OVERALL] = "نزدیک‌ترین کلی",
        [TARGET_SELECT_MODE.HYBRID] = "ترکیبی",
        [TARGET_SELECT_MODE.DYNAMIC] = "پویا",
    }
    
    local currentMode = modeNames[CONFIG.targetSelectMode] or "Unknown"
    
    local choice = gg.choice({
        "🎯 حالت انتخاب هدف: " .. currentMode,
        "📏 محدوده فعال‌سازی (متر): " .. CONFIG.activationRanges[CONFIG.targetSelectMode],
        "⚖️ تنظیمات وزندهی (حالت ترکیبی)",
        "🔧 فیلترهای پیشرفته",
        (CONFIG.aimOnlyInFOV and "🟢 فقط در FOV هدف‌گیری کند" or "🔴 فقط در FOV هدف‌گیری کند"),  -- گزینه جدید
        "🔙 بازگشت"
    }, nil, "تنظیمات انتخاب هدف پیشرفته")
    
    if choice == 1 then
        local modes = {}
        local modeValues = {}
        
        for i = 1, 4 do
            table.insert(modes, modeNames[i])
            table.insert(modeValues, i)
        end
        
        local selected = gg.choice(modes, nil, "انتخاب حالت هدف‌گیری")
        if selected then
            CONFIG.targetSelectMode = modeValues[selected]
            gg.toast("حالت هدف‌گیری: " .. modeNames[CONFIG.targetSelectMode])
        end
        
    elseif choice == 2 then
        local p = gg.prompt({"محدوده فعال‌سازی (متر):"}, 
                           {CONFIG.activationRanges[CONFIG.targetSelectMode]}, {"number"})
        if p then
            CONFIG.activationRanges[CONFIG.targetSelectMode] = tonumber(p[1]) or 9999.0
            gg.toast("محدوده فعال‌سازی: " .. CONFIG.activationRanges[CONFIG.targetSelectMode] .. "m")
        end
        
    elseif choice == 3 then
        local p = gg.prompt({
            "وزن فاصله (0-1):",
            "وزن زاویه (0-1):",
            "وزن FOV (0-1):"
        }, {
            CONFIG.hybridWeights.distance,
            CONFIG.hybridWeights.angle,
            CONFIG.hybridWeights.fov
        }, {"number", "number", "number"})
        
        if p then
            CONFIG.hybridWeights.distance = clamp(tonumber(p[1]) or 0.7, 0, 1)
            CONFIG.hybridWeights.angle = clamp(tonumber(p[2]) or 0.3, 0, 1)
            CONFIG.hybridWeights.fov = clamp(tonumber(p[3]) or 0.5, 0, 1)
            
            local total = CONFIG.hybridWeights.distance + CONFIG.hybridWeights.angle + CONFIG.hybridWeights.fov
            if total > 0 then
                CONFIG.hybridWeights.distance = CONFIG.hybridWeights.distance / total
                CONFIG.hybridWeights.angle = CONFIG.hybridWeights.angle / total
                CONFIG.hybridWeights.fov = CONFIG.hybridWeights.fov / total
            end
            
            gg.toast("وزندهی به‌روزرسانی شد")
        end
        
    elseif choice == 4 then
        local p = gg.prompt({
            "حداقل سلامت دشمن (0-100):",
            "نیاز به دید مستقیم (1=بله, 0=خیر):",
            "اولویت به دشمنان کم‌جان (1=بله, 0=خیر):"
        }, {
            CONFIG.advancedFilters.minHealth,
            CONFIG.advancedFilters.requireVisible and 1 or 0,
            CONFIG.advancedFilters.prioritizeLowHealth and 1 or 0
        }, {"number", "number", "number"})
        
        if p then
            CONFIG.advancedFilters.minHealth = clamp(tonumber(p[1]) or 0, 0, 100)
            CONFIG.advancedFilters.requireVisible = (tonumber(p[2]) or 0) == 1
            CONFIG.advancedFilters.prioritizeLowHealth = (tonumber(p[3]) or 0) == 1
            
            gg.toast("فیلترها به‌روزرسانی شد")
        end
        
    elseif choice == 5 then
        CONFIG.aimOnlyInFOV = not CONFIG.aimOnlyInFOV
        gg.toast("هدف‌گیری فقط در FOV: " .. (CONFIG.aimOnlyInFOV and "✅ فعال" or "❌ غیرفعال"))
    end
end

local function menuCharacterOffsets()
    local options = {}
    
    local uniqueTypes = {}
    for _, enemy in ipairs(enemyAddrs) do
        if enemy.type ~= 0 and not uniqueTypes[enemy.type] then
            uniqueTypes[enemy.type] = {
                name = enemy.name,
                hOffset = TYPE_HORIZONTAL_OFFSET[enemy.type] or 0.0,
                vOffset = TYPE_VERTICAL_OFFSET[enemy.type] or 0.0
            }
        end
    end
    
    for typeId, data in pairs(uniqueTypes) do
        table.insert(options, string.format("%s (ID: %d) | H:%.1f V:%.1f", 
            data.name, typeId, data.hOffset, data.vOffset))
    end
    
    if #options == 0 then
        table.insert(options, "⚠️ هیچ کاراکتری پیدا نشد")
    end
    
    table.insert(options, "➕ افزودن تنظیمات جدید")
    table.insert(options, "🔙 بازگشت")
    
    local choice = gg.choice(options, nil, "تنظیمات افست کاراکترها")
    
    if choice and choice <= #uniqueTypes then
        local selectedIndex = 1
        local selectedType = nil
        for typeId, _ in pairs(uniqueTypes) do
            if selectedIndex == choice then
                selectedType = typeId
                break
            end
            selectedIndex = selectedIndex + 1
        end
        
        if selectedType then
            local currentData = uniqueTypes[selectedType]
            local p = gg.prompt({
                "افست افقی (درجه):",
                "افست عمودی (درجه):"
            }, {
                currentData.hOffset,
                currentData.vOffset
            }, {"number", "number"})
            
            if p then
                local hOffset = tonumber(p[1]) or 0.0
                local vOffset = tonumber(p[2]) or 0.0
                
                TYPE_HORIZONTAL_OFFSET[selectedType] = hOffset
                TYPE_VERTICAL_OFFSET[selectedType] = vOffset
                
                for _, enemy in ipairs(enemyAddrs) do
                    if enemy.type == selectedType then
                        enemy.hOffset = hOffset
                        enemy.vOffset = vOffset
                    end
                end
                
                gg.toast(string.format("✅ %s: H=%.1f°, V=%.1f°", 
                    currentData.name, hOffset, vOffset))
            end
        end
        
    elseif choice == #options - 1 then
        local p = gg.prompt({
            "ID نوع کاراکتر:",
            "نام نمایشی:",
            "افست افقی (درجه):",
            "افست عمودی (درجه):"
        }, {"0", "New Character", "0.0", "0.0"}, {"number", "text", "number", "number"})
        
        if p then
            local typeId = tonumber(p[1]) or 0
            local name = p[2] or "New Character"
            local hOffset = tonumber(p[3]) or 0.0
            local vOffset = tonumber(p[4]) or 0.0
            
            TYPE_HORIZONTAL_OFFSET[typeId] = hOffset
            TYPE_VERTICAL_OFFSET[typeId] = vOffset
            TYPE_NAMES[typeId] = name
            
            gg.toast(string.format("✅ %s (ID:%d) اضافه شد", name, typeId))
        end
    end
end

local function menuPredictionSettings()
    local choice = gg.choice({
        (CONFIG.predictionEnabled and "🔴 غیرفعال‌سازی پیش‌بینی" or "🟢 فعال‌سازی پیش‌بینی"),
        (CONFIG.autoPrediction and "⏱ زمان پیش‌بینی خودکار" or "⏱ زمان پیش‌بینی دستی"),
        "🎯 زمان پیش‌بینی (میلی‌ثانیه): " .. (CONFIG.predictionTime * 1000),
        "📊 تنظیمات هموارسازی سرعت: " .. CONFIG.velocitySmoothing,
        "📈 نمایش دیباگ پیش‌بینی: " .. (CONFIG.showPredictionDebug and "روشن" or "خاموش"),
        "🔙 بازگشت"
    }, nil, "تنظیمات سیستم پیش‌بینی Frame-Aligned")
    
    if choice == 1 then
        CONFIG.predictionEnabled = not CONFIG.predictionEnabled
        gg.toast("پیش‌بینی: " .. (CONFIG.predictionEnabled and "فعال" or "غیرفعال"))
    elseif choice == 2 then
        CONFIG.autoPrediction = not CONFIG.autoPrediction
        gg.toast("زمان پیش‌بینی: " .. (CONFIG.autoPrediction and "خودکار" or "دستی"))
    elseif choice == 3 then
        local p = gg.prompt({"زمان پیش‌بینی (میلی‌ثانیه):"}, 
                           {CONFIG.predictionTime * 1000}, {"number"})
        if p then
            CONFIG.predictionTime = clamp((tonumber(p[1]) or 25) / 1000, 0.01, 0.1)
            gg.toast("زمان پیش‌بینی تنظیم شد: " .. (CONFIG.predictionTime * 1000) .. "ms")
        end
    elseif choice == 4 then
        local p = gg.prompt({"میزان هموارسازی سرعت (0-1):"}, 
                           {CONFIG.velocitySmoothing}, {"number"})
        if p then
            CONFIG.velocitySmoothing = clamp(tonumber(p[1]) or 0.3, 0, 1)
            gg.toast("هموارسازی تنظیم شد: " .. CONFIG.velocitySmoothing)
        end
    elseif choice == 5 then
        CONFIG.showPredictionDebug = not CONFIG.showPredictionDebug
        gg.toast("دیباگ پیش‌بینی: " .. (CONFIG.showPredictionDebug and "روشن" or "خاموش"))
    end
end

local function menuCharacterRanges()
    local options = {}
    
    table.insert(options, "➕ افزودن بازه جدید")
    table.insert(options, "📋 لیست بازه‌های فعلی")
    if #TYPE_RANGES > 0 then
        table.insert(options, "✏️ ویرایش بازه")
        table.insert(options, "🗑️ حذف بازه")
    end
    table.insert(options, "🎯 تنظیمات افست کاراکترها")
    table.insert(options, "🔄 بارگذاری مجدد")
    table.insert(options, "🔙 بازگشت")
    
    local choice = gg.choice(options, nil, "مدیریت بازه‌های کاراکتر (" .. #TYPE_RANGES .. " بازه)")
    
    if choice == 1 then
        local inputs = gg.prompt({
            "شروع بازه ID:",
            "پایان بازه ID:",
            "ارتفاع هدفگیری (متر):",
            "افست افقی (درجه):",
            "افست عمودی (درجه):",
            "نام نمایشی:"
        }, {"30012001", "30012011", "1.6", "0.0", "0.0", "New Character"}, 
        {"number", "number", "number", "number", "number", "text"})
        
        if inputs then
            local startID = tonumber(inputs[1])
            local endID = tonumber(inputs[2])
            local height = tonumber(inputs[3])
            local hOffset = tonumber(inputs[4])
            local vOffset = tonumber(inputs[5])
            local name = inputs[6]
            
            if startID and endID and startID <= endID then
                table.insert(TYPE_RANGES, {
                    start = startID,
                    stop = endID,
                    height = height or 1.6,
                    name = name or ("نوع " .. startID),
                    hOffset = hOffset or 0.0,
                    vOffset = vOffset or 0.0
                })
                
                for id = startID, endID do
                    TYPE_AIM_HEIGHT[id] = height or 1.6
                    TYPE_NAMES[id] = name or ("نوع " .. startID)
                    TYPE_HORIZONTAL_OFFSET[id] = hOffset or 0.0
                    TYPE_VERTICAL_OFFSET[id] = vOffset or 0.0
                end
                
                gg.toast(string.format("✅ بازه %s (%d-%d) اضافه شد", name or startID, startID, endID))
            else
                gg.alert("❌ مقادیر نامعتبر! مطمئن شوید شروع کمتر یا مساوی پایان است.")
            end
        end
        
    elseif choice == 2 then
        if #TYPE_RANGES == 0 then
            gg.alert("📭 هیچ بازه‌ای تعریف نشده است.")
        else
            local list = "📋 لیست بازه‌های کاراکتر:\n\n"
            for i, range in ipairs(TYPE_RANGES) do
                list = list .. string.format("%d. %s\n   ID: %d ~ %d\n   ارتفاع: %.1fm\n   افست: H%.1f° V%.1f°\n\n", 
                    i, range.name, range.start, range.stop, range.height, range.hOffset, range.vOffset)
            end
            gg.alert(list)
        end
        
    elseif choice == 3 then
        if #TYPE_RANGES == 0 then return end
        
        local rangeNames = {}
        for i, range in ipairs(TYPE_RANGES) do
            table.insert(rangeNames, string.format("%d. %s (ID:%d-%d)", 
                i, range.name, range.start, range.stop))
        end
        table.insert(rangeNames, "❌ انصراف")
        
        local editChoice = gg.choice(rangeNames, nil, "ویرایش کدام بازه؟")
        
        if editChoice and editChoice <= #TYPE_RANGES then
            local current = TYPE_RANGES[editChoice]
            local inputs = gg.prompt({
                "ارتفاع هدفگیری (متر):",
                "افست افقی (درجه):",
                "افست عمودی (درجه):",
                "نام نمایشی:"
            }, {
                current.height,
                current.hOffset,
                current.vOffset,
                current.name
            }, {"number", "number", "number", "text"})
            
            if inputs then
                local height = tonumber(inputs[1]) or current.height
                local hOffset = tonumber(inputs[2]) or current.hOffset
                local vOffset = tonumber(inputs[3]) or current.vOffset
                local name = inputs[4] or current.name
                
                for id = current.start, current.stop do
                    TYPE_AIM_HEIGHT[id] = height
                    TYPE_NAMES[id] = name
                    TYPE_HORIZONTAL_OFFSET[id] = hOffset
                    TYPE_VERTICAL_OFFSET[id] = vOffset
                end
                
                current.height = height
                current.hOffset = hOffset
                current.vOffset = vOffset
                current.name = name
                
                gg.toast(string.format("✅ %s ویرایش شد", name))
            end
        end
        
    elseif choice == 4 then
        if #TYPE_RANGES == 0 then return end
        
        local rangeNames = {}
        for i, range in ipairs(TYPE_RANGES) do
            table.insert(rangeNames, string.format("%d. %s (%d-%d)", 
                i, range.name, range.start, range.stop))
        end
        table.insert(rangeNames, "❌ انصراف")
        
        local delChoice = gg.choice(rangeNames, nil, "حذف کدام بازه؟")
        
        if delChoice and delChoice <= #TYPE_RANGES then
            local confirm = gg.alert("آیا مطمئنید می‌خواهید بازه " .. 
                TYPE_RANGES[delChoice].name .. " را حذف کنید؟", "✅ بله", "❌ خیر")
            
            if confirm == 1 then
                local removed = table.remove(TYPE_RANGES, delChoice)
                
                for id = removed.start, removed.stop do
                    TYPE_AIM_HEIGHT[id] = nil
                    TYPE_NAMES[id] = nil
                    TYPE_HORIZONTAL_OFFSET[id] = nil
                    TYPE_VERTICAL_OFFSET[id] = nil
                end
                
                for id = removed.start, removed.stop do
                    TYPE_AIM_HEIGHT[id] = TYPE_AIM_HEIGHT[0] or 1.6
                    TYPE_NAMES[id] = TYPE_NAMES[0] or "Unknown"
                    TYPE_HORIZONTAL_OFFSET[id] = TYPE_HORIZONTAL_OFFSET[0] or 0.0
                    TYPE_VERTICAL_OFFSET[id] = TYPE_VERTICAL_OFFSET[0] or 0.0
                end
                
                gg.toast("✅ بازه " .. removed.name .. " حذف شد")
            end
        end
        
    elseif choice == 5 then
        menuCharacterOffsets()
        
    elseif choice == 6 then
        initCharacterRanges()
        gg.toast("✅ بازه‌ها بارگذاری مجدد شدند")
    end
end

local function menuAdvancedSettings()
    local choice = gg.choice({
        "📐 FOV: " .. CONFIG.fov .. "°",
        "🌀 Smoothing: " .. CONFIG.smooth,
        "👤 Bone Mode: " .. 
            (CONFIG.boneModeGlobal == BONE_MODE.AUTO and "Auto" or
             CONFIG.boneModeGlobal == BONE_MODE.HEAD and "Head" or
             CONFIG.boneModeGlobal == BONE_MODE.CHEST and "Chest" or "Custom"),
        "📏 Custom Aim Height: " .. CONFIG.customAimHeight .. "m",
        "🎯 Offset (Yaw/Pitch): " .. CONFIG.yawOffset .. "/" .. CONFIG.pitchOffset,
        "🔄 Invert (Pitch/Yaw): " .. (CONFIG.invertPitch and "Yes" or "No") .. "/" .. 
                                   (CONFIG.invertYaw and "Yes" or "No"),
        "📊 Dynamic FOV: " .. (CONFIG.dynamicFOV and "On" or "Off"),
        "🔙 بازگشت"
    }, nil, "تنظیمات پیشرفته")
    
    if choice == 1 then
        local p = gg.prompt({"FOV (درجه):"}, {CONFIG.fov}, {"number"})
        if p then CONFIG.fov = clamp(tonumber(p[1]) or 30, 1, 360) end
    elseif choice == 2 then
        local p = gg.prompt({"Smoothing (0-1):"}, {CONFIG.smooth}, {"number"})
        if p then CONFIG.smooth = clamp(tonumber(p[1]) or 0, 0, 1) end
    elseif choice == 3 then
        CONFIG.boneModeGlobal = CONFIG.boneModeGlobal + 1
        if CONFIG.boneModeGlobal > 10 then CONFIG.boneModeGlobal = 0 end
        gg.toast("Bone Mode: " .. 
            (CONFIG.boneModeGlobal == BONE_MODE.AUTO and "Auto" or
             CONFIG.boneModeGlobal == BONE_MODE.HEAD and "Head" or
             CONFIG.boneModeGlobal == BONE_MODE.CHEST and "Chest" or "Custom"))
    elseif choice == 4 then
        local p = gg.prompt({"Custom Aim Height (متر):"}, {CONFIG.customAimHeight}, {"number"})
        if p then CONFIG.customAimHeight = clamp(tonumber(p[1]) or 1.6, 0, 3) end
    elseif choice == 5 then
        local p = gg.prompt({"Yaw Offset:", "Pitch Offset:"}, 
                           {CONFIG.yawOffset, CONFIG.pitchOffset}, {"number", "number"})
        if p then
            CONFIG.yawOffset = tonumber(p[1]) or 0
            CONFIG.pitchOffset = tonumber(p[2]) or 0
        end
    elseif choice == 6 then
        CONFIG.invertPitch = not CONFIG.invertPitch
        CONFIG.invertYaw = not CONFIG.invertYaw
        gg.toast("Invert: Pitch=" .. (CONFIG.invertPitch and "Yes" or "No") .. 
                ", Yaw=" .. (CONFIG.invertYaw and "Yes" or "No"))
    elseif choice == 7 then
        CONFIG.dynamicFOV = not CONFIG.dynamicFOV
        gg.toast("Dynamic FOV: " .. (CONFIG.dynamicFOV and "On" or "Off"))
    end
end

local function showMenu()
    local statusAim = isAimbotActive and "🟢 فعال" or "🔴 خاموش"
    local statusWall = wallActive and "🟢 فعال" or "🔴 خاموش"
    local statusFire = fireToggleActive and "🟢 فعال" or "🔴 خاموش"
    local statusPred = CONFIG.predictionEnabled and "🟢 فعال" or "🔴 خاموش"
    local statusFOVOnly = CONFIG.aimOnlyInFOV and "🟢 فعال" or "🔴 خاموش"
    
    local targetModeNames = {
        [TARGET_SELECT_MODE.CLOSEST_TO_FOV] = "نزدیک‌ترین به FOV",
        [TARGET_SELECT_MODE.CLOSEST_OVERALL] = "نزدیک‌ترین کلی",
        [TARGET_SELECT_MODE.HYBRID] = "ترکیبی",
        [TARGET_SELECT_MODE.DYNAMIC] = "پویا",
    }
    local currentTargetMode = targetModeNames[CONFIG.targetSelectMode] or "Unknown"
    
    local choice = gg.choice({
        "🔍 اسکن دوباره (کاراکتر + دوربین + دکمه شلیک)",
        "🎯 ایم‌بات " .. statusAim,
        "🧱 وال‌هاک " .. statusWall,
        "🎮 حالت دکمه شلیک " .. statusFire,
        "🎯 حالت انتخاب هدف: " .. currentTargetMode,
        "⚡ سیستم Frame-Aligned Prediction " .. statusPred,
        "🎯 فقط در FOV هدف‌گیری " .. statusFOVOnly,
        "👤 مدیریت بازه‌های کاراکتر",
        "⚙️ تنظیمات پیشرفته",
        "❌ خروج"
    }, nil, "🎯 Aimbot Advanced - به‌روزرسانی خودکار حریف - " .. #TYPE_RANGES .. " بازه")
    
    return choice
end

-- =========================
-- اجرای اصلی
-- =========================
math.randomseed(os.time())
gg.toast("🎯 Aimbot Advanced + تشخیص خودکار حریف تعویض شده فعال شد")

local scanned = scanCharacters()
if scanned then
    scanCamera()
    scanFireButton()
    applyWallHack()
    gg.toast("✅ آماده! " .. #TYPE_RANGES .. " بازه کاراکتر فعال")
    lastEmergencyUpdateTime = os.clock()
end

while true do
    if gg.isVisible() then
        gg.setVisible(false)
        local choice = showMenu()
        
        if choice == 1 then
            local success1 = scanCharacters()
            local success2 = scanCamera()
            local success3 = false
            
            if success1 then
                success3 = scanFireButton()
            end
            
            if success1 and success2 then
                applyWallHack()
                gg.toast("✅ اسکن کامل! سیستم آماده")
            end
            
        elseif choice == 2 then
            isAimbotActive = not isAimbotActive
            gg.toast(isAimbotActive and "🎯 ایم‌بات فعال" or "⏹️ ایم‌بات خاموش")
            
        elseif choice == 3 then
            wallActive = not wallActive
            if wallActive then
                applyWallHack()
                gg.toast("🧱 وال‌هاک فعال")
            else
                gg.toast("⛔ وال‌هاک غیرفعال")
            end
            
        elseif choice == 4 then
            fireToggleActive = not fireToggleActive
            gg.toast("دکمه شلیک: " .. (fireToggleActive and "فعال" or "غیرفعال"))
            
        elseif choice == 5 then
            menuTargetSelectSettings()
            
        elseif choice == 6 then
            menuPredictionSettings()
            
        elseif choice == 7 then
            menuTargetSelectSettings()   -- مستقیم به منوی تنظیمات انتخاب هدف می‌رود (گزینه جدید)
            
        elseif choice == 8 then
            menuCharacterRanges()
            
        elseif choice == 9 then
            menuAdvancedSettings()
            
        elseif choice == 10 then
            gg.toast("خداحافظ!")
            os.exit()
        end
    end
    
    if needEnemyUpdate and myCharAddr and os.clock() - lastEmergencyUpdateTime >= ENEMY_UPDATE_COOLDOWN then
        quickEnemyUpdate()
        needEnemyUpdate = false
        lastEmergencyUpdateTime = os.clock()
    end
    
    if isAimbotActive then
        aimbotLoop()
    end
    
    if wallActive then
        applyWallHack()
    end
    
    gg.sleep(1)
end
