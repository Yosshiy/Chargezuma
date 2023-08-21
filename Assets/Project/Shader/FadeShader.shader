Shader "Fade"
{
    Properties
    {
        _Progress("Progress", Range(0, 2)) = 1
        _Fade("Fade", Range(0, 1)) = 1
        [NonModifiableTextureData][NoScaleOffset]_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1("Texture2D", 2D) = "white" {}
        [NonModifiableTextureData][NoScaleOffset]_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1("Texture2D", 2D) = "white" {}
        [NonModifiableTextureData][NoScaleOffset]_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1("Texture2D", 2D) = "white" {}
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHATEST_ON 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float3 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.texCoord0;
            output.interp3.xyz =  input.viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.texCoord0 = input.interp2.xyzw;
            output.viewDirectionWS = input.interp3.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1_TexelSize;
        float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1_TexelSize;
        float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1_TexelSize;
        float _Progress;
        float _Fade;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        SAMPLER(sampler_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        TEXTURE2D(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        SAMPLER(sampler_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        TEXTURE2D(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        SAMPLER(sampler_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_R_4 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.r;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_G_5 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.g;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_B_6 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.b;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.a;
            float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_R_4 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.r;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_G_5 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.g;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_B_6 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.b;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_A_7 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.a;
            float4 _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2;
            Unity_Multiply_float4_float4((_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7.xxxx), _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0, _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2);
            float _Property_3183407bf598433e83aeb9955f475169_Out_0 = _Progress;
            float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_R_4 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.r;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_G_5 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.g;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_B_6 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.b;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_A_7 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.a;
            float4 _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2;
            Unity_Subtract_float4((_Property_3183407bf598433e83aeb9955f475169_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2);
            float4 _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2, _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2);
            float4 _OneMinus_fb80bec0adc543159a4b650176440107_Out_1;
            Unity_OneMinus_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _OneMinus_fb80bec0adc543159a4b650176440107_Out_1);
            float4 Color_ef7f6c08141b4b01baa88590495a9076 = IsGammaSpace() ? LinearToSRGB(float4(4, 3.476439, 0.4188481, 1)) : float4(4, 3.476439, 0.4188481, 1);
            float _Property_b13ef710c786431ea801d4e51bb1dad9_Out_0 = _Fade;
            float4 _Subtract_3495b6453456405083fd6645691c7ae6_Out_2;
            Unity_Subtract_float4((_Property_b13ef710c786431ea801d4e51bb1dad9_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2);
            float4 _Multiply_74c1ffeb839a44c984b0369788179766_Out_2;
            Unity_Multiply_float4_float4(Color_ef7f6c08141b4b01baa88590495a9076, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2);
            float4 _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_fb80bec0adc543159a4b650176440107_Out_1, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2);
            float4 _Add_d5cc1d325542416e95a40c59815f3159_Out_2;
            Unity_Add_float4(_Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2, _Add_d5cc1d325542416e95a40c59815f3159_Out_2);
            surface.BaseColor = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2.xyz);
            surface.Alpha = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2).x;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _ALPHATEST_ON 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1_TexelSize;
        float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1_TexelSize;
        float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1_TexelSize;
        float _Progress;
        float _Fade;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        SAMPLER(sampler_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        TEXTURE2D(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        SAMPLER(sampler_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        TEXTURE2D(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        SAMPLER(sampler_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_R_4 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.r;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_G_5 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.g;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_B_6 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.b;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.a;
            float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_R_4 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.r;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_G_5 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.g;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_B_6 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.b;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_A_7 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.a;
            float4 _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2;
            Unity_Multiply_float4_float4((_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7.xxxx), _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0, _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2);
            float _Property_3183407bf598433e83aeb9955f475169_Out_0 = _Progress;
            float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_R_4 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.r;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_G_5 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.g;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_B_6 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.b;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_A_7 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.a;
            float4 _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2;
            Unity_Subtract_float4((_Property_3183407bf598433e83aeb9955f475169_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2);
            float4 _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2, _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2);
            float4 _OneMinus_fb80bec0adc543159a4b650176440107_Out_1;
            Unity_OneMinus_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _OneMinus_fb80bec0adc543159a4b650176440107_Out_1);
            float4 Color_ef7f6c08141b4b01baa88590495a9076 = IsGammaSpace() ? LinearToSRGB(float4(4, 3.476439, 0.4188481, 1)) : float4(4, 3.476439, 0.4188481, 1);
            float _Property_b13ef710c786431ea801d4e51bb1dad9_Out_0 = _Fade;
            float4 _Subtract_3495b6453456405083fd6645691c7ae6_Out_2;
            Unity_Subtract_float4((_Property_b13ef710c786431ea801d4e51bb1dad9_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2);
            float4 _Multiply_74c1ffeb839a44c984b0369788179766_Out_2;
            Unity_Multiply_float4_float4(Color_ef7f6c08141b4b01baa88590495a9076, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2);
            float4 _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_fb80bec0adc543159a4b650176440107_Out_1, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2);
            float4 _Add_d5cc1d325542416e95a40c59815f3159_Out_2;
            Unity_Add_float4(_Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2, _Add_d5cc1d325542416e95a40c59815f3159_Out_2);
            surface.Alpha = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2).x;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define _ALPHATEST_ON 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1_TexelSize;
        float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1_TexelSize;
        float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1_TexelSize;
        float _Progress;
        float _Fade;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        SAMPLER(sampler_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        TEXTURE2D(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        SAMPLER(sampler_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        TEXTURE2D(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        SAMPLER(sampler_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_R_4 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.r;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_G_5 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.g;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_B_6 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.b;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.a;
            float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_R_4 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.r;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_G_5 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.g;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_B_6 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.b;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_A_7 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.a;
            float4 _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2;
            Unity_Multiply_float4_float4((_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7.xxxx), _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0, _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2);
            float _Property_3183407bf598433e83aeb9955f475169_Out_0 = _Progress;
            float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_R_4 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.r;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_G_5 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.g;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_B_6 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.b;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_A_7 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.a;
            float4 _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2;
            Unity_Subtract_float4((_Property_3183407bf598433e83aeb9955f475169_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2);
            float4 _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2, _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2);
            float4 _OneMinus_fb80bec0adc543159a4b650176440107_Out_1;
            Unity_OneMinus_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _OneMinus_fb80bec0adc543159a4b650176440107_Out_1);
            float4 Color_ef7f6c08141b4b01baa88590495a9076 = IsGammaSpace() ? LinearToSRGB(float4(4, 3.476439, 0.4188481, 1)) : float4(4, 3.476439, 0.4188481, 1);
            float _Property_b13ef710c786431ea801d4e51bb1dad9_Out_0 = _Fade;
            float4 _Subtract_3495b6453456405083fd6645691c7ae6_Out_2;
            Unity_Subtract_float4((_Property_b13ef710c786431ea801d4e51bb1dad9_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2);
            float4 _Multiply_74c1ffeb839a44c984b0369788179766_Out_2;
            Unity_Multiply_float4_float4(Color_ef7f6c08141b4b01baa88590495a9076, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2);
            float4 _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_fb80bec0adc543159a4b650176440107_Out_1, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2);
            float4 _Add_d5cc1d325542416e95a40c59815f3159_Out_2;
            Unity_Add_float4(_Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2, _Add_d5cc1d325542416e95a40c59815f3159_Out_2);
            surface.Alpha = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2).x;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        
        
        
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHATEST_ON 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1_TexelSize;
        float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1_TexelSize;
        float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1_TexelSize;
        float _Progress;
        float _Fade;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        SAMPLER(sampler_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        TEXTURE2D(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        SAMPLER(sampler_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        TEXTURE2D(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        SAMPLER(sampler_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_R_4 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.r;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_G_5 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.g;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_B_6 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.b;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.a;
            float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_R_4 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.r;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_G_5 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.g;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_B_6 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.b;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_A_7 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.a;
            float4 _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2;
            Unity_Multiply_float4_float4((_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7.xxxx), _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0, _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2);
            float _Property_3183407bf598433e83aeb9955f475169_Out_0 = _Progress;
            float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_R_4 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.r;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_G_5 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.g;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_B_6 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.b;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_A_7 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.a;
            float4 _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2;
            Unity_Subtract_float4((_Property_3183407bf598433e83aeb9955f475169_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2);
            float4 _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2, _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2);
            float4 _OneMinus_fb80bec0adc543159a4b650176440107_Out_1;
            Unity_OneMinus_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _OneMinus_fb80bec0adc543159a4b650176440107_Out_1);
            float4 Color_ef7f6c08141b4b01baa88590495a9076 = IsGammaSpace() ? LinearToSRGB(float4(4, 3.476439, 0.4188481, 1)) : float4(4, 3.476439, 0.4188481, 1);
            float _Property_b13ef710c786431ea801d4e51bb1dad9_Out_0 = _Fade;
            float4 _Subtract_3495b6453456405083fd6645691c7ae6_Out_2;
            Unity_Subtract_float4((_Property_b13ef710c786431ea801d4e51bb1dad9_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2);
            float4 _Multiply_74c1ffeb839a44c984b0369788179766_Out_2;
            Unity_Multiply_float4_float4(Color_ef7f6c08141b4b01baa88590495a9076, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2);
            float4 _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_fb80bec0adc543159a4b650176440107_Out_1, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2);
            float4 _Add_d5cc1d325542416e95a40c59815f3159_Out_2;
            Unity_Add_float4(_Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2, _Add_d5cc1d325542416e95a40c59815f3159_Out_2);
            surface.Alpha = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2).x;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma shader_feature _ _SAMPLE_GI
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHATEST_ON 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float3 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.texCoord0;
            output.interp3.xyz =  input.viewDirectionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.texCoord0 = input.interp2.xyzw;
            output.viewDirectionWS = input.interp3.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1_TexelSize;
        float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1_TexelSize;
        float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1_TexelSize;
        float _Progress;
        float _Fade;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        SAMPLER(sampler_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        TEXTURE2D(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        SAMPLER(sampler_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        TEXTURE2D(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        SAMPLER(sampler_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_R_4 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.r;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_G_5 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.g;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_B_6 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.b;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.a;
            float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_R_4 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.r;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_G_5 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.g;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_B_6 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.b;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_A_7 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.a;
            float4 _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2;
            Unity_Multiply_float4_float4((_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7.xxxx), _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0, _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2);
            float _Property_3183407bf598433e83aeb9955f475169_Out_0 = _Progress;
            float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_R_4 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.r;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_G_5 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.g;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_B_6 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.b;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_A_7 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.a;
            float4 _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2;
            Unity_Subtract_float4((_Property_3183407bf598433e83aeb9955f475169_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2);
            float4 _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2, _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2);
            float4 _OneMinus_fb80bec0adc543159a4b650176440107_Out_1;
            Unity_OneMinus_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _OneMinus_fb80bec0adc543159a4b650176440107_Out_1);
            float4 Color_ef7f6c08141b4b01baa88590495a9076 = IsGammaSpace() ? LinearToSRGB(float4(4, 3.476439, 0.4188481, 1)) : float4(4, 3.476439, 0.4188481, 1);
            float _Property_b13ef710c786431ea801d4e51bb1dad9_Out_0 = _Fade;
            float4 _Subtract_3495b6453456405083fd6645691c7ae6_Out_2;
            Unity_Subtract_float4((_Property_b13ef710c786431ea801d4e51bb1dad9_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2);
            float4 _Multiply_74c1ffeb839a44c984b0369788179766_Out_2;
            Unity_Multiply_float4_float4(Color_ef7f6c08141b4b01baa88590495a9076, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2);
            float4 _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_fb80bec0adc543159a4b650176440107_Out_1, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2);
            float4 _Add_d5cc1d325542416e95a40c59815f3159_Out_2;
            Unity_Add_float4(_Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2, _Add_d5cc1d325542416e95a40c59815f3159_Out_2);
            surface.BaseColor = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2.xyz);
            surface.Alpha = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2).x;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _ALPHATEST_ON 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.tangentWS;
            output.interp2.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.tangentWS = input.interp1.xyzw;
            output.texCoord0 = input.interp2.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1_TexelSize;
        float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1_TexelSize;
        float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1_TexelSize;
        float _Progress;
        float _Fade;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        SAMPLER(sampler_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        TEXTURE2D(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        SAMPLER(sampler_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        TEXTURE2D(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        SAMPLER(sampler_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_R_4 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.r;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_G_5 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.g;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_B_6 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.b;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.a;
            float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_R_4 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.r;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_G_5 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.g;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_B_6 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.b;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_A_7 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.a;
            float4 _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2;
            Unity_Multiply_float4_float4((_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7.xxxx), _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0, _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2);
            float _Property_3183407bf598433e83aeb9955f475169_Out_0 = _Progress;
            float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_R_4 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.r;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_G_5 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.g;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_B_6 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.b;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_A_7 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.a;
            float4 _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2;
            Unity_Subtract_float4((_Property_3183407bf598433e83aeb9955f475169_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2);
            float4 _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2, _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2);
            float4 _OneMinus_fb80bec0adc543159a4b650176440107_Out_1;
            Unity_OneMinus_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _OneMinus_fb80bec0adc543159a4b650176440107_Out_1);
            float4 Color_ef7f6c08141b4b01baa88590495a9076 = IsGammaSpace() ? LinearToSRGB(float4(4, 3.476439, 0.4188481, 1)) : float4(4, 3.476439, 0.4188481, 1);
            float _Property_b13ef710c786431ea801d4e51bb1dad9_Out_0 = _Fade;
            float4 _Subtract_3495b6453456405083fd6645691c7ae6_Out_2;
            Unity_Subtract_float4((_Property_b13ef710c786431ea801d4e51bb1dad9_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2);
            float4 _Multiply_74c1ffeb839a44c984b0369788179766_Out_2;
            Unity_Multiply_float4_float4(Color_ef7f6c08141b4b01baa88590495a9076, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2);
            float4 _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_fb80bec0adc543159a4b650176440107_Out_1, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2);
            float4 _Add_d5cc1d325542416e95a40c59815f3159_Out_2;
            Unity_Add_float4(_Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2, _Add_d5cc1d325542416e95a40c59815f3159_Out_2);
            surface.Alpha = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2).x;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define _ALPHATEST_ON 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1_TexelSize;
        float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1_TexelSize;
        float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1_TexelSize;
        float _Progress;
        float _Fade;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        SAMPLER(sampler_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        TEXTURE2D(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        SAMPLER(sampler_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        TEXTURE2D(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        SAMPLER(sampler_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_R_4 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.r;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_G_5 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.g;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_B_6 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.b;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.a;
            float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_R_4 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.r;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_G_5 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.g;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_B_6 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.b;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_A_7 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.a;
            float4 _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2;
            Unity_Multiply_float4_float4((_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7.xxxx), _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0, _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2);
            float _Property_3183407bf598433e83aeb9955f475169_Out_0 = _Progress;
            float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_R_4 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.r;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_G_5 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.g;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_B_6 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.b;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_A_7 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.a;
            float4 _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2;
            Unity_Subtract_float4((_Property_3183407bf598433e83aeb9955f475169_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2);
            float4 _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2, _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2);
            float4 _OneMinus_fb80bec0adc543159a4b650176440107_Out_1;
            Unity_OneMinus_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _OneMinus_fb80bec0adc543159a4b650176440107_Out_1);
            float4 Color_ef7f6c08141b4b01baa88590495a9076 = IsGammaSpace() ? LinearToSRGB(float4(4, 3.476439, 0.4188481, 1)) : float4(4, 3.476439, 0.4188481, 1);
            float _Property_b13ef710c786431ea801d4e51bb1dad9_Out_0 = _Fade;
            float4 _Subtract_3495b6453456405083fd6645691c7ae6_Out_2;
            Unity_Subtract_float4((_Property_b13ef710c786431ea801d4e51bb1dad9_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2);
            float4 _Multiply_74c1ffeb839a44c984b0369788179766_Out_2;
            Unity_Multiply_float4_float4(Color_ef7f6c08141b4b01baa88590495a9076, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2);
            float4 _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_fb80bec0adc543159a4b650176440107_Out_1, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2);
            float4 _Add_d5cc1d325542416e95a40c59815f3159_Out_2;
            Unity_Add_float4(_Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2, _Add_d5cc1d325542416e95a40c59815f3159_Out_2);
            surface.Alpha = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2).x;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define _ALPHATEST_ON 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1_TexelSize;
        float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1_TexelSize;
        float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1_TexelSize;
        float _Progress;
        float _Fade;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        SAMPLER(sampler_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        TEXTURE2D(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        SAMPLER(sampler_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        TEXTURE2D(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        SAMPLER(sampler_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_R_4 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.r;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_G_5 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.g;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_B_6 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.b;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.a;
            float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_R_4 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.r;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_G_5 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.g;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_B_6 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.b;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_A_7 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.a;
            float4 _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2;
            Unity_Multiply_float4_float4((_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7.xxxx), _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0, _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2);
            float _Property_3183407bf598433e83aeb9955f475169_Out_0 = _Progress;
            float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_R_4 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.r;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_G_5 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.g;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_B_6 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.b;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_A_7 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.a;
            float4 _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2;
            Unity_Subtract_float4((_Property_3183407bf598433e83aeb9955f475169_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2);
            float4 _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2, _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2);
            float4 _OneMinus_fb80bec0adc543159a4b650176440107_Out_1;
            Unity_OneMinus_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _OneMinus_fb80bec0adc543159a4b650176440107_Out_1);
            float4 Color_ef7f6c08141b4b01baa88590495a9076 = IsGammaSpace() ? LinearToSRGB(float4(4, 3.476439, 0.4188481, 1)) : float4(4, 3.476439, 0.4188481, 1);
            float _Property_b13ef710c786431ea801d4e51bb1dad9_Out_0 = _Fade;
            float4 _Subtract_3495b6453456405083fd6645691c7ae6_Out_2;
            Unity_Subtract_float4((_Property_b13ef710c786431ea801d4e51bb1dad9_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2);
            float4 _Multiply_74c1ffeb839a44c984b0369788179766_Out_2;
            Unity_Multiply_float4_float4(Color_ef7f6c08141b4b01baa88590495a9076, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2);
            float4 _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_fb80bec0adc543159a4b650176440107_Out_1, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2);
            float4 _Add_d5cc1d325542416e95a40c59815f3159_Out_2;
            Unity_Add_float4(_Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2, _Add_d5cc1d325542416e95a40c59815f3159_Out_2);
            surface.Alpha = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2).x;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define _ALPHATEST_ON 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1_TexelSize;
        float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1_TexelSize;
        float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1_TexelSize;
        float _Progress;
        float _Fade;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        SAMPLER(sampler_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        TEXTURE2D(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        SAMPLER(sampler_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        TEXTURE2D(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        SAMPLER(sampler_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_R_4 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.r;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_G_5 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.g;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_B_6 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.b;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.a;
            float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_R_4 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.r;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_G_5 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.g;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_B_6 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.b;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_A_7 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.a;
            float4 _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2;
            Unity_Multiply_float4_float4((_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7.xxxx), _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0, _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2);
            float _Property_3183407bf598433e83aeb9955f475169_Out_0 = _Progress;
            float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_R_4 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.r;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_G_5 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.g;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_B_6 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.b;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_A_7 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.a;
            float4 _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2;
            Unity_Subtract_float4((_Property_3183407bf598433e83aeb9955f475169_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2);
            float4 _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2, _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2);
            float4 _OneMinus_fb80bec0adc543159a4b650176440107_Out_1;
            Unity_OneMinus_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _OneMinus_fb80bec0adc543159a4b650176440107_Out_1);
            float4 Color_ef7f6c08141b4b01baa88590495a9076 = IsGammaSpace() ? LinearToSRGB(float4(4, 3.476439, 0.4188481, 1)) : float4(4, 3.476439, 0.4188481, 1);
            float _Property_b13ef710c786431ea801d4e51bb1dad9_Out_0 = _Fade;
            float4 _Subtract_3495b6453456405083fd6645691c7ae6_Out_2;
            Unity_Subtract_float4((_Property_b13ef710c786431ea801d4e51bb1dad9_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2);
            float4 _Multiply_74c1ffeb839a44c984b0369788179766_Out_2;
            Unity_Multiply_float4_float4(Color_ef7f6c08141b4b01baa88590495a9076, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2);
            float4 _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_fb80bec0adc543159a4b650176440107_Out_1, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2);
            float4 _Add_d5cc1d325542416e95a40c59815f3159_Out_2;
            Unity_Add_float4(_Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2, _Add_d5cc1d325542416e95a40c59815f3159_Out_2);
            surface.Alpha = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2).x;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHATEST_ON 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.normalWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1_TexelSize;
        float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1_TexelSize;
        float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1_TexelSize;
        float _Progress;
        float _Fade;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        SAMPLER(sampler_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1);
        TEXTURE2D(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        SAMPLER(sampler_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1);
        TEXTURE2D(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        SAMPLER(sampler_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A - B;
        }
        
        void Unity_OneMinus_float4(float4 In, out float4 Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_R_4 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.r;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_G_5 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.g;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_B_6 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.b;
            float _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7 = _SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_RGBA_0.a;
            float4 _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_a32348c16f274d50858162731bd63eb8_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_R_4 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.r;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_G_5 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.g;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_B_6 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.b;
            float _SampleTexture2D_a32348c16f274d50858162731bd63eb8_A_7 = _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0.a;
            float4 _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2;
            Unity_Multiply_float4_float4((_SampleTexture2D_f9b636e3ecd0451b95d5c39824c8bbad_A_7.xxxx), _SampleTexture2D_a32348c16f274d50858162731bd63eb8_RGBA_0, _Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2);
            float _Property_3183407bf598433e83aeb9955f475169_Out_0 = _Progress;
            float4 _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_Texture_1).GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_R_4 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.r;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_G_5 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.g;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_B_6 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.b;
            float _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_A_7 = _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0.a;
            float4 _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2;
            Unity_Subtract_float4((_Property_3183407bf598433e83aeb9955f475169_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2);
            float4 _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2;
            Unity_Multiply_float4_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _Subtract_274cf42290374a9293fa93eefbebbb1a_Out_2, _Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2);
            float4 _OneMinus_fb80bec0adc543159a4b650176440107_Out_1;
            Unity_OneMinus_float4(_Multiply_2d5d4eb27b9045199cbbe6ac14c3d239_Out_2, _OneMinus_fb80bec0adc543159a4b650176440107_Out_1);
            float4 Color_ef7f6c08141b4b01baa88590495a9076 = IsGammaSpace() ? LinearToSRGB(float4(4, 3.476439, 0.4188481, 1)) : float4(4, 3.476439, 0.4188481, 1);
            float _Property_b13ef710c786431ea801d4e51bb1dad9_Out_0 = _Fade;
            float4 _Subtract_3495b6453456405083fd6645691c7ae6_Out_2;
            Unity_Subtract_float4((_Property_b13ef710c786431ea801d4e51bb1dad9_Out_0.xxxx), _SampleTexture2D_79d0b5b818da47a493fafc604478fcfc_RGBA_0, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2);
            float4 _Multiply_74c1ffeb839a44c984b0369788179766_Out_2;
            Unity_Multiply_float4_float4(Color_ef7f6c08141b4b01baa88590495a9076, _Subtract_3495b6453456405083fd6645691c7ae6_Out_2, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2);
            float4 _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2;
            Unity_Multiply_float4_float4(_OneMinus_fb80bec0adc543159a4b650176440107_Out_1, _Multiply_74c1ffeb839a44c984b0369788179766_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2);
            float4 _Add_d5cc1d325542416e95a40c59815f3159_Out_2;
            Unity_Add_float4(_Multiply_272a953c9a0f448fad85f0f501d1cc6d_Out_2, _Multiply_aa60b8d56a8a47e38776c5ee65b84f62_Out_2, _Add_d5cc1d325542416e95a40c59815f3159_Out_2);
            surface.Alpha = (_Add_d5cc1d325542416e95a40c59815f3159_Out_2).x;
            surface.AlphaClipThreshold = 0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}