Shader "Custom/all_in_one"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)   // Base color of the object
        _MainTex ("Base Texture", 2D) = "white" {}        // Texture map
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1)  // Specular color
        _Shininess ("Shininess", Range(0.1, 100)) = 16      // Shininess (specular exponent)

        [Toggle] _UseAmbient ("Use Ambient", Int) = 1.0
        [Toggle] _UseDiffuse ("Use Diffuse", Int) = 1.0
        [Toggle] _UseSpecular ("Use Specular", Int) = 1.0
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalRenderPipeline" "RenderType" = "Opaque" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;  // Object space position
                float3 normalOS : NORMAL;      // Object space normal
                float2 uv : TEXCOORD0;         // Texture UV
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION; // Homogeneous clip-space position
                float3 normalWS : TEXCOORD1;      // World space normal
                float3 viewDirWS : TEXCOORD2;     // World space view direction
                float2 uv : TEXCOORD0;            // UV for texturing
            };

            // Declare the base texture and sampler
            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseColor;   // Declare the base color (modifiable in inspector)
                float4 _SpecColor;   // Specular color (modifiable in inspector)
                float _Shininess;    // Shininess (specular exponent)
                int _UseAmbient;
                int _UseDiffuse;
                int _UseSpecular;
            CBUFFER_END

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                // Transform the object space position to homogeneous clip space
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                // Transform the object space normal to world space
                OUT.normalWS = normalize(TransformObjectToWorldNormal(IN.normalOS));
                // Compute view direction in world space
                float3 worldPosWS = TransformObjectToWorld(IN.positionOS.xyz);
                OUT.viewDirWS = normalize(GetCameraPositionWS() - worldPosWS);
                // Pass the UV to the fragment shader
                OUT.uv = IN.uv;
                return OUT;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
                // Sample the base texture
                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                
                // Fetch the main light in URP
                Light mainLight = GetMainLight();
                half3 lightDir = normalize(mainLight.direction);

                half3 finalColor = texColor.rgb * _BaseColor.rgb;

                // Normalize the world space normal
                half3 normalWS = normalize(IN.normalWS);

                // Calculate Lambertian diffuse lighting (NdotL)
                half NdotL = saturate(dot(normalWS, lightDir));

                // Calculate ambient lighting using spherical harmonics (SH)
                if (_UseAmbient==1) {
                    half3 ambientSH = SampleSH(normalWS);
                    finalColor *= ambientSH;
                }

                // Combine the base color and texture with the diffuse light
                if (_UseDiffuse) {
                    half3 diffuse = texColor.rgb * _BaseColor.rgb * NdotL;
                    finalColor += diffuse;
                }


                if (_UseSpecular) {
                    // Calculate the reflection direction for specular
                    half3 reflectDir = reflect(-lightDir, normalWS);

                    // Calculate specular contribution using Blinn-Phong model
                    half3 viewDir = normalize(IN.viewDirWS);
                    half specFactor = pow(saturate(dot(reflectDir, viewDir)), _Shininess);
                    half3 specular = _SpecColor.rgb * specFactor;

                    finalColor += specular;
                }

                // Combine diffuse lighting, ambient lighting, and specular highlights
                // half3 finalColor = diffuse + ambientSH * texColor.rgb * _BaseColor.rgb + specular;

                // Return the final color
                return half4(finalColor, 1.0);
            }

            ENDHLSL
        }
    }
}