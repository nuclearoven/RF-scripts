 behaviour("RandomLivery")

function RandomLivery:Start()
	self.Data = self.gameObject.GetComponent(DataContainer)
	self.Mat = self.Data.GetTextureArray("State")
	if self.Data.HasFloat("Metallic1")	
	then self.metallic = self.Data.GetFloatArray("Metallic")
	else self.metallic = {}
		for i=1,#self.Mat do
			self.metallic[i]= self.targets.Material.GetFloat("_Glossiness")
		end
	end
	local selected = Mathf.RoundToInt(Random.Range(1, #self.Mat+1))
	local renderers = self.transform.parent.gameObject.GetComponentsInChildren(Renderer)
    for _, renderer in pairs(renderers) do
        if renderer and renderer.materials then
            for _, material in pairs(renderer.materials) do
                if material.name == self.targets.Material.name .. " (Instance)"
				then material.SetTexture("_MainTex", self.Mat[selected])
					material.SetFloat("_Glossiness", self.metallic[selected])
                end
            end
        end
    end
end 