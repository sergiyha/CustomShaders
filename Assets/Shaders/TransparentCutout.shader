Shader "Custom/TransparentCutout" {
	Properties {
		
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_HeighMap ("_HeighMap", 2D) = "white" {}
		_CutOut("_CutOut", Range(-0.5 ,1)) = 0.5
		_TrashHold("_TrashHold", Range(0.0001 ,1)) = 0.5
	
	}
	SubShader {
		// ZWrite ON
		
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		
		Blend SrcAlpha OneMinusSrcAlpha
	

		 LOD 200
		Pass{
		 Cull FRONT
		//AlphaToMask On

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag


			sampler2D _MainTex;
			sampler2D _HeighMap;

			uniform float4 _MainTex_ST;
			uniform float4 _HeighMap_ST;
		

			float _CutOut;
			float _TrashHold;
	  		struct vertexInput
       		{
				 float4 vertex : POSITION;
				 float4 texcoord: TEXCOORD0;
				 float4 tangent: TANGENT;
			};
           
			struct vertexOutput
			{
 	    		float4 pos : SV_POSITION;
				float4 tex : TEXCOORD0;
				float4 posWorld: TEXCOORD1;
			};


			vertexOutput vert(vertexInput v)
			{
        		vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex); 
				o.posWorld = mul(unity_ObjectToWorld, v.vertex );
				o.tex  = v.texcoord;
				return o;
			}


			float4 frag(vertexOutput i) : COLOR
			{

         		float4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
         		float4 heighMap = tex2D(_HeighMap, i.tex.xy * _HeighMap_ST.xy + _HeighMap_ST.zw);

				if (_CutOut + _TrashHold > heighMap.r )
				{
					float d_c = heighMap.r - _CutOut;
					float percent_d = d_c/_TrashHold;
					tex.a = percent_d;
			   }
		  
        
			   if(heighMap.r < _CutOut)
			   {
			
	       		discard;

			   }

				tex.a = clamp(tex.a,0,1);
         		return float4(tex);
			}

		ENDCG
		}

		Pass{
				Cull BACK
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag


			sampler2D _MainTex;
			sampler2D _HeighMap;

			uniform float4 _MainTex_ST;
			uniform float4 _HeighMap_ST;
		

			float _CutOut;
			float _TrashHold;
	  		struct vertexInput
       		{
				 float4 vertex : POSITION;
				 float4 texcoord: TEXCOORD0;
				 float4 tangent: TANGENT;
			};
           
			struct vertexOutput
			{
 	    		float4 pos : SV_POSITION;
				float4 tex : TEXCOORD0;
				float4 posWorld: TEXCOORD1;
			};


			vertexOutput vert(vertexInput v)
			{
        		vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex); 
				o.posWorld = mul(unity_ObjectToWorld, v.vertex );
				o.tex  = v.texcoord;
				return o;
			}


			float4 frag(vertexOutput i) : COLOR
			{

         		float4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
         		float4 heighMap = tex2D(_HeighMap, i.tex.xy * _HeighMap_ST.xy + _HeighMap_ST.zw);

				if (_CutOut + _TrashHold > heighMap.r )
				{
					float d_c = heighMap.r - _CutOut;
					float percent_d = d_c/_TrashHold;
					tex.a = percent_d;
			   }
		  
        
			   if(heighMap.r < _CutOut)
			   {
			
	       		discard;

			   }

				tex.a = clamp(tex.a,0,1);
         		return float4(tex);
			}

			ENDCG
		}

	}
	FallBack "Diffuse"
}
