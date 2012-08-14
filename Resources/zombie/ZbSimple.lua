-- ��򵥵Ľ�ʬ
-- by f.f.

module(..., package.seeall)

local ZbBase = require("zombie.ZbBase")
local ResMgr = require("ResMgr")
local FSM = require("utils.FSM")
local Coor = require("utils.Coor")
local Move = require("action.Move")
local Hurt = require("action.Hurt")
ZbSimple=class(ZbBase.ZbBase)
function new(...) return ZbSimple.new(...) end

local walkAniName = "ZbSimple"
local walkAni = ResMgr.getAni(walkAniName)

function ZbSimple:ctor()
	self.name = "ZbSimple."..self.id

	self.sprite = CCLayer:node()
	local shd = CCSprite:spriteWithSpriteFrame(ResMgr.getImageFrame("plantShadow"));
	shd:setPosition(10, -50)
	self.sprite:addChild(shd)

	local sp = CCSprite:spriteWithSpriteFrame(ResMgr.getAniFaceFrame(walkAniName))
	sp:runAction(CCRepeatForever:actionWithAction(CCAnimate:actionWithAnimation(walkAni)))
	self.sprite:addChild(sp)

	local hpEmpty = CCSprite:spriteWithFile(rpath("hpEmpty.png"))
	hpEmpty:setPosition(-15, 65)
	self.sprite:addChild(hpEmpty)

	self.hpBar = CCProgressTimer:progressWithFile(rpath("hpFull.png"))

	self.hpBar:setType(kCCProgressTimerTypeHorizontalBarLR)
	self.hpBar:setPercentage(100)
	self.hpBar:setPosition(-15, 65)
	self.sprite:addChild(self.hpBar, 2, -1)

	self.speedX = -0.1
	self.hpMax = 100
	self.hp = self.hpMax
	FSM.set(self, "ZSS_WALK")
end

function ZbSimple:eat()
	print("ZbSimple eat")
end

local FSM_INFO = {
	ZSS_WALK={
		function(self)
			local grid = Coor.x2Grid(self.x)
--			print("x:"..self.x..",y:"..self.y.." gx:"..gx.." gy:"..gy)
--			if self:myLine() ~= nil then print("l:"..self:myLine().id) end
			if self:myLine() ~= nil and self:myLine():getPlantByGrid(gx) ~= nil then return "ZSS_EAT" end
		end,
		deal=Move.uniformMove
	},
	ZSS_EAT={
		deal=Hurt.eat
	},
}

function ZbSimple:update()
	FSM.run(self, FSM_INFO)
--	self:walk()
end
