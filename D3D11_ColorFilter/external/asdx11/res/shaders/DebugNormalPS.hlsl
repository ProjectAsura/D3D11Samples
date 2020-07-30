//-------------------------------------------------------------------------------------------------
// File : DebugNormalPS.hlsl
// Desc : Pixel Shader For Debug Binormal.
// Copyright(c) Project Asura. All right resreved.
//-------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------------
#include "Math.hlsli"


///////////////////////////////////////////////////////////////////////////////////////////////////
// VSOutput structure
///////////////////////////////////////////////////////////////////////////////////////////////////
struct VSOutput
{
    float4 Position : SV_POSITION;
    float2 TexCoord : TEXCOORD;
};

//-------------------------------------------------------------------------------------------------
// Textures and Samplers.
//-------------------------------------------------------------------------------------------------
Texture2D<uint4>    NormalMap : register(t0);
SamplerState        LinearSmp : register(s0);


//-------------------------------------------------------------------------------------------------
//      メインエントリーポイントです.
//-------------------------------------------------------------------------------------------------
float4 main(const VSOutput input) : SV_TARGET
{
    float3 N;
    float3 T;
    float3 B;
    float2 size;
    NormalMap.GetDimensions(size.x, size.y);
    uint4 encodedTBN = NormalMap.Load(int3(size.x * input.TexCoord.x, size.y * input.TexCoord.y, 0));

    DecodeTBN(encodedTBN, N, T, B);

    return float4(N * 0.5f + 0.5f, 1.0f);
}