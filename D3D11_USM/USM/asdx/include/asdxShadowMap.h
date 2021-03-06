﻿//-------------------------------------------------------------------------------------------
// File : asdxShadowMap.h
// Desc : Shadow Map Module.
// Copyright(c) Project Asura. All right reserved.
//-------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------
#include <asdxTypedef.h>
#include <asdxRenderTarget.h>
#include <asdxDepthStencilTarget.h>


namespace asdx {

/////////////////////////////////////////////////////////////////////////////////////////////
// ShadowMap class
/////////////////////////////////////////////////////////////////////////////////////////////
class ShadowMap
{
    //=======================================================================================
    // list of friend classes and methods.
    //=======================================================================================
    /* NOTHING */

public:
    /////////////////////////////////////////////////////////////////////////////////////////
    // TargetDesc structure
    /////////////////////////////////////////////////////////////////////////////////////////
    struct TargetDesc
    {
        u32                     Width;          //!< 横幅です.
        u32                     Height;         //!< 縦幅です.
        u32                     MipLevels;      //!< ミップレベルです.
        u32                     ArraySize;      //!< 配列サイズです.
        DXGI_FORMAT             Format;         //!< フォーマットです.
        DXGI_SAMPLE_DESC        SampleDesc;     //!< サンプルの概要です.
        u32                     CPUAccessFlags; //!< CPUアクセスフラグです.
        u32                     MiscFlags;      //!< フラグです.

        //-----------------------------------------------------------------------------------
        //! @brief      コンストラクタです.
        //-----------------------------------------------------------------------------------
        TargetDesc()
        : Width         ( 0 )
        , Height        ( 0 )
        , MipLevels     ( 0 )
        , ArraySize     ( 0 )
        , Format        ( DXGI_FORMAT_UNKNOWN )
        , CPUAccessFlags( 0 )
        , MiscFlags     ( 0 )
        { /* DO_NOTHING */ }
    };

    //////////////////////////////////////////////////////////////////////////////////////////
    // SamplerDesc structure
    //////////////////////////////////////////////////////////////////////////////////////////
    struct SamplerDesc
    {
        D3D11_FILTER                Filter;             //!< フィルタです.
        D3D11_TEXTURE_ADDRESS_MODE  AddressU;           //!< アドレスモードUです.
        D3D11_TEXTURE_ADDRESS_MODE  AddressV;           //!< アドレスモードVです.
        D3D11_TEXTURE_ADDRESS_MODE  AddressW;           //!< アドレスモードWです.
        D3D11_COMPARISON_FUNC       CompFunc;           //!< 深度比較関数です.
        FLOAT                       BorderColor[ 4 ];   //!< 境界カラーです.

        //------------------------------------------------------------------------------------
        //! @brief      コンストラクタです.
        //------------------------------------------------------------------------------------
        SamplerDesc()
        : Filter    ( D3D11_FILTER_MIN_MAG_MIP_LINEAR )
        , AddressU  ( D3D11_TEXTURE_ADDRESS_CLAMP )
        , AddressV  ( D3D11_TEXTURE_ADDRESS_CLAMP )
        , AddressW  ( D3D11_TEXTURE_ADDRESS_CLAMP )
        , CompFunc  ( D3D11_COMPARISON_LESS )
        {
            BorderColor[ 0 ] = 1.0f;
            BorderColor[ 1 ] = 1.0f;
            BorderColor[ 2 ] = 1.0f;
            BorderColor[ 3 ] = 1.0f;
        }
    };


    //=======================================================================================
    // public variables.
    //=======================================================================================
    /* NOTHING */


    //========================================================================================
    // public methods.
    //========================================================================================

    //----------------------------------------------------------------------------------------
    //! @brief      コンストラクタです.
    //----------------------------------------------------------------------------------------
    ShadowMap();

    //----------------------------------------------------------------------------------------
    //! @brief      デストラクタです.
    //----------------------------------------------------------------------------------------
    virtual ~ShadowMap();

    //----------------------------------------------------------------------------------------
    //! @brief      初期化処理です.
    //----------------------------------------------------------------------------------------
    bool Init( ID3D11Device* pDevice, const TargetDesc& targetDesc, const SamplerDesc& samplerDesc );

    //----------------------------------------------------------------------------------------
    //! @brief      終了処理です.
    //----------------------------------------------------------------------------------------
    void Term();
   
    //----------------------------------------------------------------------------------------
    //! @brief      描画ターゲットの横幅を取得します.
    //----------------------------------------------------------------------------------------
    u32 GetWidth() const;

    //----------------------------------------------------------------------------------------
    //! @brief      描画ターゲットの縦幅を取得します.
    //----------------------------------------------------------------------------------------
    u32 GetHeight() const;

    //----------------------------------------------------------------------------------------
    //! @brief      描画ターゲットの配列サイズを取得します.
    //----------------------------------------------------------------------------------------
    u32 GetArraySize() const;

    //----------------------------------------------------------------------------------------
    //! @brief      ビューポートを取得します.
    //----------------------------------------------------------------------------------------
    D3D11_VIEWPORT* GetViewport();

    //----------------------------------------------------------------------------------------
    //! @brief      レンダーターゲットビューを取得します.
    //----------------------------------------------------------------------------------------
    ID3D11RenderTargetView* GetRTV();

    //----------------------------------------------------------------------------------------
    //! @brief      深度ステンシルビューを取得します.
    //----------------------------------------------------------------------------------------
    ID3D11DepthStencilView* GetDSV();

    //----------------------------------------------------------------------------------------
    //! @brief      シェーダリソースビューを取得します.
    //----------------------------------------------------------------------------------------
    ID3D11ShaderResourceView* GetSRV_FromRT();

    //----------------------------------------------------------------------------------------
    //! @brief      シェーダリソースビューを取得します.
    //----------------------------------------------------------------------------------------
    ID3D11ShaderResourceView* GetSRV_FromDST();

    //----------------------------------------------------------------------------------------
    //! @brief      サンプラーステートを取得します.
    //----------------------------------------------------------------------------------------
    ID3D11SamplerState* GetSmp();

protected:
    //========================================================================================
    // protected variables.
    //========================================================================================
    /* NOTHING */

    //========================================================================================
    // protected methods.
    //========================================================================================
    /* NOTHING */

private:
    //========================================================================================
    // private variables.
    //========================================================================================
    RenderTarget2D                  m_RT;                           //!< レンダーターゲットです.
    DepthStencilTarget              m_DST;                          //!< 深度ステンシルターゲットです.
    ID3D11SamplerState*             m_pSmp;                         //!< サンプラーステートです.
    D3D11_VIEWPORT                  m_Viewport;                     //!< ビューポートの配列です.
    u32                             m_Width;                        //!< 描画ターゲットの横幅です.
    u32                             m_Height;                       //!< 描画ターゲットの縦幅です.
    u32                             m_ArraySize;                    //!< 描画ターゲットの配列サイズです.

    //========================================================================================
    // private methods.
    //========================================================================================
    ShadowMap       ( const ShadowMap& );       // アクセス禁止.
    void operator = ( const ShadowMap& );       // アクセス禁止.
};


} // namespace asdx
