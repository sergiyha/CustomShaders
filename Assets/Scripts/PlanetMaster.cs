using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SocialPlatforms;
using UnityEngine.XR.WSA.WebCam;

//[ExecuteInEditMode]
public class PlanetMaster : MonoBehaviour
{
    private Transform _waterTransform;

    public Transform WaterTransform
    {
        get
        {
			if (_waterTransform == null)
			{
				_waterTransform = transform.Find(PlanetConsts.Water);
			}
            //_waterTransform = _waterTransform ?? gameObject.transform.Find(PlanetConsts.Water);
            return _waterTransform;
        }
    }
    
    
}

public class PlanetConsts
{
    public const string Water = "Water";
}