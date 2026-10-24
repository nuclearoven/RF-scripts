 behaviour("RandomSquadron")

function RandomSquadron:Start()
	self.Data = self.gameObject.GetComponent(DataContainer)
	self.Mat = self.Data.GetTextureArray("State")
	if self.Data.HasFloat("Metallic1")	
	then self.metallic = self.Data.GetFloatArray("Metallic")
	else self.metallic = {}
		for i=1,#self.Mat do
			self.metallic[i]= self.targets.Material.GetFloat("_Glossiness")
		end
	end
	if GameObject.Find("squadDesignator(Clone)") ~= nil
	then self.selected = Mathf.RoundToInt(GameObject.Find("squadDesignator(Clone)").transform.position.x)
	else self.selected = Mathf.RoundToInt(Random.Range(1, #self.Mat+1))
		self.designator = GameObject.Instantiate(self.targets.designator,Vector3(self.selected,0,0),Quaternion.identity)
	end
    self.targets.Material.SetTexture("_MainTex", self.Mat[self.selected])
	self.targets.Material.SetFloat("_Glossiness", self.metallic[self.selected])
end 