// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "unity/learning/shaders/textureShader"
{
    Properties
    {
        _Color("Color", Color) = (1.0,1.0,1.0,1.0)
        
        _MainTex("Diffuse Texture", 2D) = "white" {}
        _Vector3("Vector3", Vector) = (1.0, 1.0, 1.0 ,1.0)
        _RimColor("RimColo", Color) = (1.0, 1.0, 1.0 ,1.0)
        _SpecColor("SpecColor", Color) = (1.0, 1.0, 1.0, 1.0)
        _Shinines("Shinines", FLOAT)  = 1.
        _RimPower("_RimPower", Range(0.1,10.0)) = 3.0
    }
    
    SubShader
    {
        Tags
        {
            "LightModel" = "ForwardBase"
        }
        
        Pass
        {
           CGPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           
           uniform float4 _Color;
           uniform float4 _RimColor;
           uniform float4 _SpecColor;
           uniform float _Shinines;
           uniform float _RimPower;
           
           uniform float4 _MainTex_ST;
           uniform sampler2D _MainTex;
           
           uniform float4 _LightColor0;
           
           
           struct vertexInput
           {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord: TEXCOORD0;
           };
           
           struct vertexOutput
           {
                float4 pos : SV_POSITION;
                float4 tex : TEXCOORD0;
                float4 posWorld: TEXCOORD1;
                float3 normalDirection : TEXCOORD2; 
           };
           
           vertexOutput vert(vertexInput v)
           {
                vertexOutput o;
                       
                o.pos = UnityObjectToClipPos(v.vertex); 
                o.posWorld = mul(unity_ObjectToWorld, v.vertex );
                o.normalDirection = normalize(mul(float4(v.normal,0.0), unity_WorldToObject).xyz);
                o.tex  = v.texcoord;
                return o;
           }
           
           float4 frag(vertexOutput i) : COLOR
           {
                float3 normalDirection = i.normalDirection;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 lightDirection; //= normalize(_WorldSpaceLightPos0.xyz);
                float atten; //= 1.0;
                
             //   _Vector3 = _MainTex_ST;
                if(_WorldSpaceLightPos0.w == 0)
                {
                    atten = 1.0;               
                    lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                }
                else
                {
                    float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
                    float distance = length(fragmentToLightSource);
                    atten = 1/distance;
                    lightDirection = normalize(fragmentToLightSource.xyz);
                }
                
                float3 diffuseReflection = 
                atten * 
                _LightColor0.xyz *
                saturate(dot(normalDirection,lightDirection));
                
                float3 specularReflection = 
                atten *
                _LightColor0.xyz *
                _SpecColor.xyz *
                saturate(dot(normalDirection,lightDirection)) * 
                pow(saturate( dot(reflect(-lightDirection,normalDirection),viewDirection)), _Shinines);
                
               // float3 rim = 1 -  saturate(dot(viewDirection, normalDirection));
                float3 rim = 1 -  saturate(dot(viewDirection, normalDirection));
                float3 rimLighting = atten * _LightColor0 * saturate(dot(normalDirection, lightDirection)) * pow(rim, _RimPower);
                 
                float3 finalReflection = specularReflection + diffuseReflection + UNITY_LIGHTMODEL_AMBIENT + rimLighting; 
                
                //Text maps
                float4 tex = tex2D(_MainTex, i.tex.xyz * _MainTex_ST.xy + _MainTex_ST.zw);
                return float4(tex *  finalReflection,0);
           
           
           }
           ENDCG
           
        }
    }

}

