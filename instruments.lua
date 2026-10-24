-- Register the behaviour
behaviour("instruments")
local a = false
function instruments:Start()
	self.plen = self.targets.Plane.gameObject.GetComponent(Airplane)
	if self.plen == nil
	then self.plen = self.targets.Plane.gameObject.GetComponent(Helicopter)
	end
	self.rb = self.targets.Plane.gameObject.GetComponent(Rigidbody)
	self.Data = self.gameObject.GetComponent(DataContainer)
	self.speed = self.Data.GetFloat("spd")
	self.climbplier = self.Data.GetFloat("Climb")
	self.G = self.Data.GetFloat("G")
	if self.targets.cumpiss~= nil
	then self.cumpiss = self.targets.cumpiss
		self.invertedHeading =false
	else self.cumpiss = self.targets.headingIndicator
		self.invertedHeading = true
	end
	if self.Data.HasFloat("mach")
	then self.mach = self.Data.GetFloat("mach")
	end
	if self.Data.HasFloat("AoA")
	then self.aoa = self.Data.GetFloat("AoA")
	end
	self.light = self.Data.GetColor("light")
end
function instruments:Update()
	self.targets.alt1.transform.localRotation = Quaternion.Euler(0,0,self.plen.altitude * -0.36)  
	self.targets.alt2.transform.localRotation = Quaternion.Euler(0,0,self.plen.altitude * -0.036)  
	self.targets.ias.transform.localRotation = Quaternion.Euler(0,0,self.rb.velocity.magnitude * self.speed)
	self.targets.climb.transform.localRotation = Quaternion.Euler(0,0,self.rb.velocity.y * self.climbplier)
	self.cumpiss.transform.localRotation = Quaternion.Euler(0,0,self.plen.transform.eulerAngles.y*(self.invertedHeading and 1 or -1))
	local acceleration = self.transform.InverseTransformDirection(self.rb.angularVelocity).x*self.rb.velocity.magnitude*0.6
	local Gdirection = acceleration<=0 and 1 or -1
	local Gforce = Mathf.Sqrt(acceleration^2+9.8^2)/9.8*Gdirection-Gdirection
	self.targets.g.transform.localRotation = Quaternion.Euler(0,0,Gforce * self.G)
	if self.aoa ~= nil
	then local angleOfAttack = Mathf.Atan(self.transform.InverseTransformDirection(self.rb.velocity.normalized-self.rb.transform.forward).y)
		self.targets.AoA.transform.localRotation = Quaternion.Euler(0,0,-Mathf.Abs(angleOfAttack*57.3 * self.aoa))
	end
	Debug.DrawRay(self.rb.transform.position,self.rb.velocity.normalized,Color.red)
	Debug.DrawRay(self.rb.transform.position,self.rb.transform.forward,Color.green)
	if self.targets.mach ~= nil
	then self.targets.mach.transform.localRotation = Quaternion.Euler(0,0,self.rb.velocity.magnitude/200 * self.mach)
	end
	if self.targets.slip ~= nil
	then local SlipAngle = self.rb.transform.forward-self.rb.velocity
		self.targets.slip.transform.localRotation = Quaternion.Euler(0,0,Mathf.Clamp((SlipAngle.x+SlipAngle.z)/2,-15,15))
		self.targets.turn.transform.localRotation = Quaternion.Euler(0,0, self.rb.angularVelocity.y*-50)
	end
	if Input.GetKeyBindButtonDown(KeyBinds.Kick)
    then a = not a
		if a == false
		then self.targets.material.SetColor("_EmissionColor", self.light)
			self.targets.InstrumentMaterial.SetColor("_EmissionColor", self.light)
		else self.targets.material.SetColor("_EmissionColor", Color.black)
			self.targets.InstrumentMaterial.SetColor("_EmissionColor", Color.black)
		end
		if self.targets.lightSwitch
		then self.targets.lightSwitch.SetActive(not a)
		end
	end
end
