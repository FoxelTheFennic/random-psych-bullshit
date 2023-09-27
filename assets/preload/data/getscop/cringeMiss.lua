function onCreate()
    missCount = 1
end

function noteMiss(id, noteData, noteType, isSustainNote)
    missCount = missCount + 1
    playSound('vine-boom', 1);
    makeLuaSprite('cringe' .. id, 'cringe', 0, 0)
    scaleObject('cringe' .. id, screenWidth/1920, screenHeight/1080)
    setObjectCamera('cringe' .. id, 'other')
    setObjectOrder('cringe' .. id, 1000 + missCount + id)
	addLuaSprite('cringe' .. id, true)
    runTimer('waite' .. id, 0.2, 1)
end

function onTimerCompleted(tag)
    if string.find(tag, "waite") then
        idid = string.gsub(tag, "waite", "")
        doTweenAlpha('cringer' .. idid, 'cringe' .. idid, 0, 1, 'linear');
    end
end
function onTweenCompleted(tag)
    if string.find(tag, "cringer") then
        ididr = string.gsub(tag, "cringer", "")
        removeLuaSprite('cringe' .. ididr, false)
    end
end