// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


//Shows the grayscale of the depth from the camera.
 
Shader "Custom/DepthShader"
{
properties
{
        _MainTex("Main Tex",2d) = "white"{}
}
    SubShader
    {
        Tags { "RenderType"="Opaque" }
 
        Pass
        {
 
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            
           uniform sampler2D _MainTex;  
            
            
            #include "UnityCG.cginc"
 

             struct v2f
             {
                float4 pos : SV_POSITION;
               // float4 vertex : TEXCOORD1;
                float2 uv : TEXCOORD0;
                
             };
                       
           sampler2D _CameraDepthTexture;
            v2f vert( appdata_img v )
            {
                v2f o;
                o.pos = UnityObjectToClipPos (v.vertex);
              //  o.vertex = v.vertex;
                o.uv =  v.texcoord.xy;
                return o;
            }    
             
            half4 frag(v2f i) : SV_Target 
            {      
            
                float depth = tex2D (_CameraDepthTexture, i.uv).r;
               // depth = Linear01Depth(depth);
                float diff_y =  sin((i.pos.x )/10+depth + _Time[1]*(depth+10))/300 ;
                float diff_x = sin(i.pos.y/10 +_Time[1])/30;
                float4 depthTex  = tex2D(_CameraDepthTexture, i.uv + float2(0, diff_y ));
                
              //  float4 final = float4(depth +sin( depth - _Time[1]*2 ),depth ,depth,depth);
                       
                return depthTex.r;
            }
                     
 
            ENDCG
        }
    }
    FallBack "VertexLit"
}