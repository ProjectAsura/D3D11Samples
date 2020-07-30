//-----------------------------------------------------------------------------
// File : ColorFilterCS.hlsl
// Desc : Color Filter.
// Copyright(c) Project Asura. All right reserved.
//-----------------------------------------------------------------------------

// �X���b�h�T�C�Y.
#define THREAD_SIZE (8)

// Shader Model 5�n���ǂ���?
#define IS_SM5 (1)

///////////////////////////////////////////////////////////////////////////////
// ColorFilterParam structure
///////////////////////////////////////////////////////////////////////////////
cbuffer CbColorFilter : register(b0)
{
    uint2       DipsatchArgs : packoffset(c0);   // Dispatch()���\�b�h�ɓn��������.
    float4x4    ColorMatrix  : packoffset(c1);   // �J���[�ϊ��s��.
};

//-----------------------------------------------------------------------------
// Resources.
//-----------------------------------------------------------------------------
Texture2D<float4>   Input   : register(t0);
RWTexture2D<float4> Output  : register(u0);


//-----------------------------------------------------------------------------
//! @brief      �X���b�h�O���[�v�̃^�C�����O���s��.
//!
//! @param[in]      dispatchGridDim     ID3D12GraphicsCommandList::Dipatch(X, Y, Z)�œn����(X, Y)�̒l.
//! @param[in]      groupId             �O���[�vID
//! @param[in]      groupTheradId       �O���[�v�X���b�hID.
//! @return     �X���b�hID��ԋp����.
//-----------------------------------------------------------------------------
uint2 CalcSwizzledThreaId(uint2 dispatchDim, uint2 groupId, uint2 groupThreadId)
{
    // "CTA" (Cooperative Thread Array) == Thread Group in DirectX terminology
    const uint2 CTA_Dim = uint2(THREAD_SIZE, THREAD_SIZE);
    const uint N = 16; // 16 �X���b�h�O���[�v�ŋN��.

    // 1�^�C�����̃X���b�h�O���[�v�̑���.
    uint number_of_CTAs_in_a_perfect_tile = N * (dispatchDim.y);

    // �l�����銮�S�ȃ^�C���̐�.
    uint number_of_perfect_tiles = dispatchDim.x / N;

    // ���S�ȃ^�C���ɂ�����X���b�h�O���[�v�̑���.
    uint total_CTAs_in_all_perfect_tiles = number_of_perfect_tiles * N * dispatchDim.y - 1;
    uint threadGroupIDFlattened = dispatchDim.x * groupId.y + groupId.x;

    // ���݂̃X���b�h�O���[�v����^�C��ID�ւ̃}�b�s���O.
    uint tile_ID_of_current_CTA = threadGroupIDFlattened / number_of_CTAs_in_a_perfect_tile;
    uint local_CTA_ID_within_current_tile = threadGroupIDFlattened % number_of_CTAs_in_a_perfect_tile;

    uint local_CTA_ID_y_within_current_tile = local_CTA_ID_within_current_tile / N;
    uint local_CTA_ID_x_within_current_tile = local_CTA_ID_within_current_tile % N;
 
    if(total_CTAs_in_all_perfect_tiles < threadGroupIDFlattened)
    {
        // �Ō�̃^�C���ɕs���S�Ȏ���������A�Ō�̃^�C�������CTA���N�����ꂽ�ꍇ�ɂ̂ݎ��s�����p�X.
        uint x_dimension_of_last_tile = dispatchDim.x % N;
    #if IS_SM5
        // SM5.0���ƃR���p�C���G���[�ɂȂ�̂ő΍�.
        if (x_dimension_of_last_tile > 0)
        {
            local_CTA_ID_y_within_current_tile = local_CTA_ID_within_current_tile / x_dimension_of_last_tile;
            local_CTA_ID_x_within_current_tile = local_CTA_ID_within_current_tile % x_dimension_of_last_tile;
        }
    #else
        local_CTA_ID_y_within_current_tile = local_CTA_ID_within_current_tile / x_dimension_of_last_tile;
        local_CTA_ID_x_within_current_tile = local_CTA_ID_within_current_tile % x_dimension_of_last_tile;
    #endif
    }

    uint swizzledThreadGroupIDFlattened = tile_ID_of_current_CTA * N
      + local_CTA_ID_y_within_current_tile * dispatchDim.x
      + local_CTA_ID_x_within_current_tile;

    uint2 swizzledThreadGroupID;
    swizzledThreadGroupID.y = swizzledThreadGroupIDFlattened / dispatchDim.x;
    swizzledThreadGroupID.x = swizzledThreadGroupIDFlattened % dispatchDim.x;

    uint2 swizzledThreadID;
    swizzledThreadID.x = CTA_Dim.x * swizzledThreadGroupID.x + groupThreadId.x;
    swizzledThreadID.y = CTA_Dim.y * swizzledThreadGroupID.y + groupThreadId.y;

    return swizzledThreadID;
}


//-----------------------------------------------------------------------------
//      ���C���G���g���[�|�C���g�ł�.
//-----------------------------------------------------------------------------
[numthreads(THREAD_SIZE, THREAD_SIZE, 1)]
void main
(
    uint3 groupId       : SV_GroupID,
    uint3 groupThreadId : SV_GroupThreadID
)
{
    uint2 id = CalcSwizzledThreaId(DipsatchArgs, groupId.xy, groupThreadId.xy);
    Output[id] = mul(ColorMatrix, Input[id]);
}