﻿-- This file is subject to copyright - contact swampservers@gmail.com for more information.
function EFFECT:Init(data)
    local pos = data:GetOrigin()
    local grav = Vector(0, 0, math.random(50, 60))
    local offset = Vector()
    self.emitter = {}
    local particle = self.Sparkle:Add("pyroteknik/sparkle", pos)
    particle:SetVelocity((Vector(0, 0, 1) + (VectorRand() * 0.1)) * math.random(15, 30))
    particle:SetDieTime(math.random(0.5, 0.8))
    particle:SetStartAlpha(255)
    particle:SetEndAlpha(0)
    particle:SetStartSize(3)
    particle:SetEndSize(1.5)
    particle:SetRoll(math.random(0.5, 10))
    particle:SetRollDelta(math.Rand(-0.2, 0.2))
    particle:SetColor(255, 255, 255)
    particle:SetCollide(false)
    particle:SetGravity(grav)
    grav = grav + Vector(0, 0, math.random(-10, -5))
    offset = offset + Vector(math.random(1, 5), math.random(.5, 5), math.random(1.5, 6))
    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end
