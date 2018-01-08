// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "unity/learning/shaders/Shader_1"{
		Properties{
			_Color("Color", Color) = (1.0,1.0,1.0,1.0)
		}
		SubShader{
			Pass{
				CGPROGRAM

				//pragmas
				#pragma vertex vert
				#pragma fragment frag

				//usr define variables 
				uniform float4 _Color;		

				//base input structs
				struct vertexInput {
					float4 vertex : POSITION;
				};

				struct vertexOutput {
					float4 pos : SV_POSITION;
				};
				//vertex function 

				vertexOutput vert(vertexInput v) {
					vertexOutput o;
					o.pos =  UnityObjectToClipPos(v.vertex);
					return o;
				}

				float4 frag(vertexOutput i) : COLOR{
					half4 c;
					c = _Color;
					return c;
				}


					//fragment function

				ENDCG
			}
	}

}