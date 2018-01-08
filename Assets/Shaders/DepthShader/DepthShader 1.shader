// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


//Shows the grayscale of the depth from the camera.
 
Shader "Custom/DepthShader_1"
{
properties
{
        _MainTex("Main Tex",2d) = "white"{}
}
    SubShader
    {
       // Tags { "RenderType"="Opaque" }
 
        Pass
        {
 
            CGPROGRAM
           // #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            
           uniform sampler2D _MainTex;  
            
            
            #include "UnityCG.cginc"
 

             struct v2f
             {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
             };
                       
            sampler2D _CameraDepthTexture;
            v2f vert( appdata_img v )
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
                o.uv =  v.texcoord.xy;
                return o;
            }    
             
            half4 frag(v2f i) : COLOR
            {      
                float depth = 1;// tex2D (_CameraDepthTexture, i.uv).r;
               // depth = Linear01Depth(depth);
                
                       
                return depth;
            }
                     
 
            ENDCG
        }
    }
    FallBack "VertexLit"
}