
void MainLight_half(float3 WorldPos, out half3 Direction, out half3 Color, out half DistanceAtten, out half ShadowAtten)
{
    Direction = half3(0.5, 0.5, 0);
    Color = 1;
    DistanceAtten = 1;
    ShadowAtten = 1;

    #ifndef SHADERGRAPH_PREVIEW
        #if SHADOWS_SCREEN
            half4 clipPos = TransformWorldToHClip(WorldPos);
            half4 shadowCoord = ComputeScreenPos(clipPos);
        #else
            half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
        #endif
            Light mainLight = GetMainLight(shadowCoord);
            Direction = mainLight.direction;
            Color = mainLight.color;
            DistanceAtten = mainLight.distanceAttenuation;

        #if !defined(_MAIN_LIGHT_SHADOWS) || defined(_RECEIVE_SHADOWS_OFF)
            ShadowAtten = 1.0h;
        #endif

        #if SHADOWS_SCREEN
            ShadowAtten = SampleScreenSpaceShadowmap(shadowCoord);
        #else
            
            ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
            half shadowStrength = GetMainLightShadowStrength();
            ShadowAtten = SampleShadowmap(shadowCoord, TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), shadowSamplingData, shadowStrength, false);
        #endif
    #endif
}