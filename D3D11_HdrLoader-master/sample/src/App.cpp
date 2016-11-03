﻿//-------------------------------------------------------------------------------------------------
// File : App.cpp
// Desc : Sample Application.
// Copyright(c) Project Asura. All right reserved.
//-------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------------
#include <asdxMisc.h>
#include <asdxLogger.h>
#include <asdxResHDR.h>
#include <asdxRenderState.h>
#include <App.h>
#include <cassert>
#include <new>


namespace /* anonymous */ {

//-------------------------------------------------------------------------------------------------
//! @brief      HDRデータからリソーステクスチャを生成します.
//!
//! @param[in]      value       HDRデータ.
//! @return     HDRデータから生成したリソーステクスチャを返却します.
//-------------------------------------------------------------------------------------------------
asdx::ResTexture CreateFromHdr( const asdx::ResHDR& value )
{
    asdx::ResTexture result;
    result.Width        = value.GetWidth();
    result.Height       = value.GetHeight();
    result.Depth        = 0;
    result.MipMapCount  = 1;
    result.SurfaceCount = 1;
    result.Format       = DXGI_FORMAT_R32G32B32_FLOAT;

    f32* pPixels = nullptr;
    value.GetFloatPixels( &pPixels );
    assert( pPixels != nullptr );

    auto pSubResource = new (std::nothrow) asdx::SubResource();
    assert( pSubResource != nullptr );
    pSubResource->Width      = value.GetWidth();
    pSubResource->Height     = value.GetHeight();
    pSubResource->Pitch      = value.GetWidth() * sizeof(f32) * 3;
    pSubResource->SlicePitch = pSubResource->Pitch * value.GetHeight();
    pSubResource->pPixels    = reinterpret_cast<u8*>( pPixels );
    assert( pSubResource->pPixels != nullptr );

    result.pResources = pSubResource;

    return result;
}


} // namespace /* anonymous */


///////////////////////////////////////////////////////////////////////////////////////////////////
// App class
///////////////////////////////////////////////////////////////////////////////////////////////////

//-------------------------------------------------------------------------------------------------
//      コンストラクタです.
//-------------------------------------------------------------------------------------------------
App::App()
: asdx::Application( L"Sample", 960, 540, nullptr, nullptr, nullptr )
{
}

//-------------------------------------------------------------------------------------------------
//      デストラクタです.
//-------------------------------------------------------------------------------------------------
App::~App()
{
}

//-------------------------------------------------------------------------------------------------
//      初期化処理です.
//-------------------------------------------------------------------------------------------------
bool App::OnInit()
{
    // スプライトの初期化に失敗しました.
    if ( !m_Sprite.Init( m_pDevice.GetPtr(), f32(m_Width), f32(m_Height) ) )
    {
        ELOG( "Error : Sprite Initialize Failed." );
        return false;
    }

    // レンダーステートの初期化.
    if ( !asdx::RenderState::GetInstance().Init( m_pDevice.GetPtr() ) )
    {
        ELOG( "Error : RenderState Initailize Failed. ");
        return false;
    }

    // ファイルパスを探す.
    const char16* loadPath = L"res/galileo_probe.hdr";

    std::wstring path;
    if ( !asdx::SearchFilePath( loadPath, path ) )
    {
        ELOG( "Error : File Not Found." );
        return false;
    }

    // HDRをロード.
    asdx::ResHDR hdr;
    if ( !hdr.Load( path.c_str() ) )
    {
        ELOG( "Error : File Load Failed. path = %s", path.c_str() );
        return false;
    }

    // リソーステクスチャにコンバート.
    asdx::ResTexture res = CreateFromHdr( hdr );

    // HDRを解放.
    hdr.Release();

    // テクスチャデータを生成.
    if ( !m_Texture.Create( m_pDevice.GetPtr(), m_pDeviceContext.GetPtr(), res ) )
    {
        ELOG( "Error : Create Texture Failed." );
        res.Release();
        return false;
    }

    // リソーステクスチャを解放.
    res.Release();

    // 正常終了.
    return true;
}

//-------------------------------------------------------------------------------------------------
//      終了処理です.
//-------------------------------------------------------------------------------------------------
void App::OnTerm()
{
    // テクスチャを解放.
    m_Texture.Release();

    // レンダーステートの終了処理.
    asdx::RenderState::GetInstance().Term();
}

//-------------------------------------------------------------------------------------------------
//      フレーム遷移処理です.
//-------------------------------------------------------------------------------------------------
void App::OnFrameMove(asdx::FrameEventArgs& param)
{
    ASDX_UNUSED_VAR( param );
}

//-------------------------------------------------------------------------------------------------
//      フレーム描画処理です.
//-------------------------------------------------------------------------------------------------
void App::OnFrameRender(asdx::FrameEventArgs& param)
{
    ASDX_UNUSED_VAR( param );

    {
        ID3D11RenderTargetView* pRTV = nullptr;
        ID3D11DepthStencilView* pDSV = nullptr;
        pRTV = m_ColorTarget2D.GetTargetView();
        pDSV = m_DepthTarget2D.GetTargetView();

        if ( pRTV == nullptr || pDSV == nullptr )
        { return; }

        m_pDeviceContext->OMSetRenderTargets( 1, &pRTV, pDSV );
        m_pDeviceContext->RSSetViewports( 1, &m_Viewport );

        m_pDeviceContext->ClearRenderTargetView( pRTV, m_ClearColor );
        m_pDeviceContext->ClearDepthStencilView( pDSV, D3D11_CLEAR_DEPTH | D3D11_CLEAR_STENCIL, 1.0f, 0 );

        auto size = 400;
        m_Sprite.SetTexture( m_Texture.GetSRV(), asdx::RenderState::GetInstance().GetSmp( asdx::SamplerType::LinearClamp ) );
        m_Sprite.Begin( m_pDeviceContext.GetPtr(), asdx::Sprite::SHADER_TYPE_TEXTURE2D );
        m_Sprite.Draw( m_Width / 2 - size /2 , m_Height / 2 - size / 2, size, size );
        m_Sprite.End( m_pDeviceContext.GetPtr() );
    }

    Present( 0 );
}

//-------------------------------------------------------------------------------------------------
//      リサイズ処理です.
//-------------------------------------------------------------------------------------------------
void App::OnResize(const asdx::ResizeEventArgs& param)
{
    m_Sprite.SetScreenSize( f32(param.Width), f32(param.Height) );
}

//-------------------------------------------------------------------------------------------------
//      キーイベントの処理です.
//-------------------------------------------------------------------------------------------------
void App::OnKey(const asdx::KeyEventArgs& param)
{
}

//-------------------------------------------------------------------------------------------------
//      マウスイベントの処理です.
//-------------------------------------------------------------------------------------------------
void App::OnMouse(const asdx::MouseEventArgs& param)
{
}