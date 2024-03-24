﻿-- This file is subject to copyright - contact swampservers@gmail.com for more information.
AddCSLuaFile()
ENT.Type = "anim"
ENT.Model = Model("models/golf rack/golf rack.mdl")
ENT.PutterModel = Model("models/pyroteknik/putter.mdl")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetMoveType(MOVETYPE_NONE)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:DrawShadow(false)
    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:EnableMotion(false)
    end

    if SERVER then
        self:SetTrigger(true)
        self:SetUseType(SIMPLE_USE)
    end
end
