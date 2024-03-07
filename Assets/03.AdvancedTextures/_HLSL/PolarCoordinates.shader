Shader "Learning/AdvancedTexturing/HLSL/PolarCoordinates"
{
    Properties
    {
        _BaseColor("Base color", Color) = (1,1,1,1)
        _BaseTex("Base Texture", 2D) = "white" {}
        _Center("Center", Vector) = (0.5, 0.5, 0, 0)
        _RadialScale("Radial Scale", Float) = 1
        _LengthScale("Length Scale", Float) = 1
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
                float2 _Center;
                float _RadialScale;
                float _LengthScale;
            CBUFFER_END

            
            
            v2f vert (appdata v)
            {
                v2f o;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.uv = TRANSFORM_TEX(v.uv, _BaseTex);
                return o;
            }

            float2 cartesianToPolar(float cartUV)
            {
                float2 offset = cartUV - _Center;
                float radius = length(offset) * 2;
                float angle = atan2(offset.x, offset.y) / (2.0f * PI);

                return float2(radius, angle);
            }
            
            float4 frag (v2f i) : SV_Target
            {
                float2 radialUV = cartesianToPolar(i.uv);
                radialUV.x *= _RadialScale;
                radialUV.y *= _LengthScale;
                
                float4 textureSample = tex2D(_BaseTex, radialUV);
                return _BaseColor * textureSample;
            }
            ENDHLSL
        }
    }
}