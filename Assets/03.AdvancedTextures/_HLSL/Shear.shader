Shader "Learning/AdvancedTexturing/HLSL/Shear"
{
    Properties
    {
        _BaseColor("Base color", Color) = (1,1,1,1)
        _BaseTex("Base Texture", 2D) = "white" {}
        _ShearAmount("Shear Amount", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "Queue" = "Geometry"
            "RenderPipeline" = "UniversalPipeline"
        }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                
            struct appdata
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 positionCS : SV_POSITION;
            };
            
            sampler2D _BaseTex;

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;
                float4 _BaseTex_ST;
                float2 _ShearAmount;
            CBUFFER_END

            
            
            v2f vert (appdata v)
            {
                float2x2 shearMatrix = float2x2(
                    1, -_ShearAmount.x,
                    -_ShearAmount.y, 1
                );
                
                v2f o;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex);
                o.uv = mul(shearMatrix, o.uv);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                
                float4 textureSample = tex2D(_BaseTex, i.uv);
                return _BaseColor * textureSample;
            }
            ENDHLSL
        }
    }
}
