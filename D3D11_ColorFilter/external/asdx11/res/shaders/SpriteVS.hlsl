//-------------------------------------------------------------------------------------------------
// File : SpriteVS.hlsl
// Desc : Sprite Vertex Shader.
// Copyright(c) Project Asura. All right reserved.
//-------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------------
#include "SpriteDef.hlsli"


//-------------------------------------------------------------------------------------------------
//! @brief      頂点シェーダメインエントリーポイントです.
//-------------------------------------------------------------------------------------------------
VSOutput main( VSInput input )
{
    VSOutput output = (VSOutput)0;

    // 頂点座標を変換.
    float4 localPos = float4( input.Position, 1.0f );

    // 出力値設定.
    output.Position = mul( TransformMtx, localPos );
    output.Color    = input.Color;
    output.TexCoord = input.TexCoord;

    // ピクセルシェーダに出力.
    return output;
}
