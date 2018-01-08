// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "unity/learning/shaders/specular+" 
{
    Properties
    {
        _Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _SpecularColor("SpecColor", Color) = (1.0, 1.0, 1.0, 1.0)
        _Shininnes("Shinines", float) = 10.0
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
            uniform float4 _SpecularColor;
            uniform float _Shininnes;
            
            uniform float4 _LightColor0;
            
            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };            
            
            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float3 normalDir : TEXCOORD0;
                float3 worldPos: TEXCOORD1;
            };    
            
            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o; 
               
            }        
            
            float4 frag(vertexOutput i) : COLOR
            {
                 //lighting
                float3 normalDirection = i.normalDir; 
                float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.worldPos.xyz));
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz); 
                float atten = 1.0;
                 
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDirection, lightDirection));
                float3 specularReflection = 
                atten 
                * _LightColor0.rgb
                * _SpecularColor.rgb 
                * max(0.0, dot(normalDirection, lightDirection)) 
                * pow(max(0.0, dot(reflect(-lightDirection, normalDirection),viewDirection)), _Shininnes);
                
                float3 lightFinal = specularReflection + diffuseReflection + UNITY_LIGHTMODEL_AMBIENT;
                
                return float4(lightFinal * _Color.rgb, 1.0);
            }
           ENDCG

        }
    
    } 

}