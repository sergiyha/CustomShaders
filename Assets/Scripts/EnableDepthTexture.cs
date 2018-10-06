using UnityEngine;


public class EnableDepthTexture : MonoBehaviour
{
	void Start()
	{
		 Camera.main.depthTextureMode = DepthTextureMode.Depth;
		//Camera.main.depth  
	}
}