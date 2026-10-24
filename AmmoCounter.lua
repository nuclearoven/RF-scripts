-- Register the behaviour
behaviour("AmmoCounter")

function AmmoCounter:Start()
	self.wpn = self.targets.wpn.GetComponent(Weapon)
	self.Numbers ={}
	for i=1,self.transform.childCount do
		self.Numbers[i] = self.transform.GetChild(i-1)
	end
end

function AmmoCounter:Update()
	for i=1,#self.Numbers do
		self.Numbers[i].localEulerAngles = Vector3(Mathf.Floor(10*(self.wpn.ammo/10^i))*-36,0,0)
	end
end
