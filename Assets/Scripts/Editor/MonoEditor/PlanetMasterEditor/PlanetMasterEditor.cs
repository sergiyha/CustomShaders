using UnityEditor;
using UnityEngine;

namespace MonoEditor.PlanetMasterEditor
{
	[CustomEditor(typeof(PlanetMaster))]
	public class PlanetMasterEditor : Editor
	{
		private float _scale = 2.561f;
		private PlanetMaster _pM;

		public override void OnInspectorGUI()
		{
			_pM = _pM ?? (PlanetMaster)target;
			_scale = _pM.WaterTransform.localScale.x;

			DrawDefaultInspector();


			_scale = EditorGUILayout.Slider(_scale, 1, 3);
			_pM.WaterTransform.localScale = new Vector3(_scale, _scale, _scale);
		}
	}
}