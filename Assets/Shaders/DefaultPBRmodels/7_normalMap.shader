// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "unityCookie/tut/beginner/7 - Normal Map"{
	Properties {
		_Color ("Color Tint", Color) = (1.0,1.0,1.0,1.0)
		_MainTex ("Diffuse Texture", 2D) = "white" {}
		_BumpMap ("Normal Texture", 2D) = "bump" {}
		_BumpDepth ("Bump Depth", Range(-2.0,2.0)) = 1
		_SpecColor ("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Float) = 10
		_RimColor ("Rim Color", Color) = (1.0,1.0,1.0,1.0)
		_RimPower ("Rim Power", Range(0.1,10.0)) = 3.0
		
		_EmTex("Emission Texure", 2d) = "white"{}
		_EmPower ("Emission Power", Range(0.1,1.0)) = 1
	}
	SubShader {
		Pass {
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers flash
			
			//user defined variables
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _BumpMap;
			uniform float4 _BumpMap_ST;
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float4 _RimColor;
			uniform float _Shininess;
			uniform float _RimPower;
			uniform float _BumpDepth;
			
			
			uniform float4 _EmTex_ST;
			uniform float _EmPower;
			uniform sampler2D _EmTex;
			
			//unity defined variables
			uniform float4 _LightColor0;
			
			//base input structs
			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 tangent : TANGENT;
			};
			struct vertexOutput{
				float4 pos : SV_POSITION;
				float4 tex : TEXCOORD0;
				float4 posWorld : TEXCOORD1;
				float3 normalWorld : TEXCOORD2;
				float3 tangentWorld : TEXCOORD3;
				float3 binormalWorld : TEXCOORD4;
			};
			
			//vertex Function
			
			vertexOutput vert(vertexInput v){
				vertexOutput o;
				
				o.normalWorld = normalize( mul( float4( v.normal, 0.0 ), unity_WorldToObject ).xyz );
				o.tangentWorld = normalize( mul( unity_ObjectToWorld, v.tangent ).xyz );
				o.binormalWorld = normalize( cross(o.normalWorld, o.tangentWorld) * v.tangent.w );
				
				o.posWorld = mul(unity_ObjectToWorld, sin(v.vertex));
				o.pos = UnityObjectToClipPos(float4(v.vertex.x +sin( v.vertex.y - _Time[1]*2 ),v.vertex.y,v.vertex.z,v.vertex.a));
				o.tex = v.texcoord;
				
				return o;
			}
			
			//fragment function
			
			float4 frag(vertexOutput i) : COLOR
			{
				float3 viewDirection = normalize( _WorldSpaceCameraPos.xyz - i.posWorld.xyz );
				float3 lightDirection;
				float atten;
				
				if(_WorldSpaceLightPos0.w == 0.0){ //directional light
					atten = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else
				{
					float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
					float distance = length(fragmentToLightSource);
					atten = 1.0/distance;
					lightDirection = normalize(fragmentToLightSource);
				}
				//Texture Maps
				float4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				float4 texN = tex2D(_BumpMap, i.tex.xy * _BumpMap_ST.xy + _BumpMap_ST.zw);
				float4 emTex = tex2D(_EmTex, i.tex.xy * _EmTex_ST.xy + _EmTex_ST.zw);
				
				
				
				//unpackNormal function
				float3 localCoords = float3(2.0 * texN.ag - float2(1.0, 1.0), 0.0);
				localCoords.z = _BumpDepth;
				
				//normal transpose matrix
				float3x3 local2WorldTranspose = float3x3(
					i.tangentWorld,
					i.binormalWorld,
					i.normalWorld
				);
				
				//calculate normal direction
				float3 normalDirection = normalize( mul( localCoords, local2WorldTranspose ) );
				
				//Lighting
				float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normalDirection, lightDirection));
				float3 specularReflection = diffuseReflection * _SpecColor.xyz * pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)) , _Shininess);
				
				//Rim Lighting
				float rim = 1 - saturate(dot(viewDirection, normalDirection));
				float3 rimLighting = saturate( dot( normalDirection, lightDirection ) * _RimColor.xyz * _LightColor0.xyz * pow( rim, _RimPower ) );
				
				float3 lightFinal = UNITY_LIGHTMODEL_AMBIENT.xyz + diffuseReflection + specularReflection + rimLighting + (emTex.rgb * _EmPower);
				
				float4 lastStep = float4(tex.xyz * lightFinal * _Color.xyz, 1.0);
				if(any(emTex.rgb == float3(0.0, 0.0, 0.0)))
				{
				    lastStep.rgb = float3(1,1,0);
				}
				return lastStep;
			}
			
			ENDCG
			
		}
		
			
		}

	}
	//Fallback "Specular"
