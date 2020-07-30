﻿//-------------------------------------------------------------------------------------------------
// File : asdxRenderState.h
// Desc : Render State Module.
// Copyright(c) Project Asura. All right reserved.
//-------------------------------------------------------------------------------------------------
#pragma once

//-------------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------------
#include <d3d11.h>
#include <asdxRef.h>


namespace asdx {

///////////////////////////////////////////////////////////////////////////////////////////////////
// BlendType enum
///////////////////////////////////////////////////////////////////////////////////////////////////
enum BlendType
{
    Opaque = 0,             //!< 不透明
    AlphaBlend,             //!< アルファブレンド.
    Additive,               //!< 加算.
    Subtract,               //!< 減算.
    Premultiplied,          //!< 事前乗算済みアルファブレンド.
    Multiply,               //!< 乗算.
    Screen,                 //!< スクリーン.
    NumBlendType,
};

///////////////////////////////////////////////////////////////////////////////////////////////////
// DepthType enum
///////////////////////////////////////////////////////////////////////////////////////////////////
enum DepthType
{
    None = 0,           //!< 深度テストなし, 深度書き込みなし.
    Default,            //!< 深度テストあり, 深度書き込みあり.
    Readonly,           //!< 深度テストあり, 深度書き込みなし.
    WriteOnly,          //!< 深度テストなし, 深度書き込みあり.
    DefaultReverseZ,
    ReadonlyReverseZ,
    NumDepthType,
};

///////////////////////////////////////////////////////////////////////////////////////////////////
// RasterizerType enum
///////////////////////////////////////////////////////////////////////////////////////////////////
enum RasterizerType
{
    CullNone = 0,               //!< カリングなし. マルチサンプル無効.
    CullNoneMS,                 //!< カリングなし. マルチサンプル有効.
    CullClockWise,              //!< 時計回りをカリング. マルチサンプル無効.
    CullClockWiseMS,            //!< 時計回りをカリング. マルチサンプル有効.
    CullCounterClockWise,       //!< 反時計周りをカリング. マルチサンプル無効.
    CullCounterClockWiseMS,     //!< 反時計周りをカリング. マルチサンプル有効.
    WireFrame,                  //!< ワイヤーフレーム. マルチサンプル無効.
    WireFrameMS,                //!< ワイヤーフレーム. マルチサンプル有効.
    NumRasterizerType
};

///////////////////////////////////////////////////////////////////////////////////////////////////
// SamplerType enum
///////////////////////////////////////////////////////////////////////////////////////////////////
enum SamplerType
{
    PointWrap = 0,       //!< ポイントサンプリング・繰り返し
    PointClamp,          //!< ポイントサンプリング・クランプ.
    PointMirror,         //!< ポイントサンプリング・ミラー.
    LinearWrap,          //!< 線形補間・繰り返し.
    LinearClamp,         //!< 線形補間・クランプ.
    LinearMirror,        //!< 線形補間・ミラー.
    AnisotropicWrap,     //!< 異方性補間・繰り返し.
    AnisotropicClamp,    //!< 異方性補間・クランプ.
    AnisotropicMirror,   //!< 異方性補間・ミラー.
    NumSamplerType,
};

///////////////////////////////////////////////////////////////////////////////////////////////////
// SamplerComparisonType enum
///////////////////////////////////////////////////////////////////////////////////////////////////
enum SamplerComparisonType
{
    PointLEqual = 0,            //!< ポイントサンプリング. LessEqual
    PointGEqual,                //!< ポイントサンプリング. GreaterEqual
    LinearLEqual,               //!< 線形補間. LessEqual
    LinearGEqual,               //!< 線形補間. GraterEqual
    AnisotropicLEqual,          //!< 異方性補間. LessEqual
    AnisotropicGEqual,          //!< 異方性補間. GreaterEqual
    NumSamplerComparisonType,
};

///////////////////////////////////////////////////////////////////////////////////////////////////
// RenderState class
///////////////////////////////////////////////////////////////////////////////////////////////////
class RenderState
{
    //=============================================================================================
    // list of friend classes and methods.
    //=============================================================================================
    /* NOTHING */

public:
    //=============================================================================================
    // public variables.
    //=============================================================================================
    /* NOTHING */

    //=============================================================================================
    // public methods.
    //=============================================================================================

    //---------------------------------------------------------------------------------------------
    //! @brief      唯一のインスタンスを取得します.
    //!
    //! @return     唯一のインスタンスを返却します.
    //---------------------------------------------------------------------------------------------
    static RenderState& GetInstance();

    //---------------------------------------------------------------------------------------------
    //! @brief      初期化処理を行います.
    //!
    //! @param[in]      pDevice         デバイスです.
    //! @retval true    初期化に成功.
    //! @retval false   初期化に失敗.
    //---------------------------------------------------------------------------------------------
    bool Init( ID3D11Device* pDevice );

    //---------------------------------------------------------------------------------------------
    //! @brief      終了処理を行います.
    //---------------------------------------------------------------------------------------------
    void Term();

    //---------------------------------------------------------------------------------------------
    //! @brief      初期化済みかどうかチェックします.
    //!
    //! @retval true    初期化済みです.
    //! @retval false   未初期化です.
    //---------------------------------------------------------------------------------------------
    bool IsInit() const;

    //---------------------------------------------------------------------------------------------
    //! @brief      ブレンドステートを取得します.
    //!
    //! @param[in]      type        ブレンドタイプ.
    //! @return     ブレンドステートを返却します.
    //---------------------------------------------------------------------------------------------
    ID3D11BlendState* GetBS( BlendType type ) const;

    //---------------------------------------------------------------------------------------------
    //! @brief      深度ステンシルステートを取得します.
    //!
    //! @param[in]      type        深度タイプ.
    //! @return     深度ステンシルステートを返却します.
    //---------------------------------------------------------------------------------------------
    ID3D11DepthStencilState* GetDSS( DepthType type ) const;

    //---------------------------------------------------------------------------------------------
    //! @brief      ラスタライザーステートを取得します.
    //!
    //! @param[in]      type        ラスタライザータイプ.
    //! @return     ラスタライザーステートを返却します.
    //---------------------------------------------------------------------------------------------
    ID3D11RasterizerState* GetRS( RasterizerType type ) const;

    //---------------------------------------------------------------------------------------------
    //! @brief      サンプラーステートを取得します.
    //!
    //! @param[in]      type        サンプラータイプ.
    //! @return     サンプラーステートを返却します.
    //---------------------------------------------------------------------------------------------
    ID3D11SamplerState* GetSmp( SamplerType type ) const;

    //---------------------------------------------------------------------------------------------
    //! @brief      サンプラーコンパリソンステートを取得します.
    //!
    //! @param[in]      type        サンプラーコンパリソンタイプ.
    //! @return     サンプラーコンパリソンステートを返却します.
    //---------------------------------------------------------------------------------------------
    ID3D11SamplerState* GetSmpCmp( SamplerComparisonType type ) const;

protected:
    //==============================================================================================
    // protected variables.
    //==============================================================================================
    /* NOTHING */

    //==============================================================================================
    // protected methods.
    //==============================================================================================
    /* NOTHING */

private:
    //==============================================================================================
    // private variables.
    //==============================================================================================
    bool                            m_IsInit;                           //!< 初期化済みかどうか.
    RefPtr<ID3D11BlendState>        m_BS [ NumBlendType ];              //!< ブレンドステート.
    RefPtr<ID3D11DepthStencilState> m_DSS[ NumDepthType ];              //!< 深度ステンシルステート.
    RefPtr<ID3D11RasterizerState>   m_RS [ NumRasterizerType ];         //!< ラスタライザーステート.
    RefPtr<ID3D11SamplerState>      m_SS [ NumSamplerType ];            //!< サンプラーステート.
    RefPtr<ID3D11SamplerState>      m_SCS[ NumSamplerComparisonType ];  //!< 比較用サンプラーステート.

    //==============================================================================================
    // private methods.
    //==============================================================================================

    //----------------------------------------------------------------------------------------------
    //! @brief      コンストラクタです.
    //----------------------------------------------------------------------------------------------
    RenderState();

    //----------------------------------------------------------------------------------------------
    //! @brief      デストラクタです.
    //----------------------------------------------------------------------------------------------
    virtual ~RenderState();
};

} // namespace asdx
