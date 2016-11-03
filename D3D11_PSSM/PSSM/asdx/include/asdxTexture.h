﻿//--------------------------------------------------------------------------------------------
// File : asdxTexture.h
// Desc : Texture Module.
// Copyright(c) Project Asura. All right reserved.
//--------------------------------------------------------------------------------------------

#ifndef __ASDX_TEXTURE_H__
#define __ASDX_TEXTURE_H__

//---------------------------------------------------------------------------------------------
// Includes
//---------------------------------------------------------------------------------------------
#include <d3d11.h>


namespace asdx {

//////////////////////////////////////////////////////////////////////////////////////////////
// TEXTURE_FORMAT enum
//////////////////////////////////////////////////////////////////////////////////////////////
enum TEXTURE_FORMAT
{
    FORMAT_INVALID = -1,    //!< 無効なフォーマットです.
    FORMAT_A8 = 0,          //!< A8 フォーマットです.
    FORMAT_L8,              //!< L8 フォーマットです.
    FORMAT_R8G8B8A8,        //!< RGBA(8,8,8,8) フォーマットです.
    FORMAT_BC1,             //!< BC1フォーマットです.
    FORMAT_BC2,             //!< BC2フォーマットです.
    FORMAT_BC3,             //!< BC3フォーマットです.

    NUM_FORMAT              //!< フォーマット数です.
};


///////////////////////////////////////////////////////////////////////////////////////////////
// Texture2D class
///////////////////////////////////////////////////////////////////////////////////////////////
class Texture2D
{
    //=========================================================================================
    // list of friend classes and methods.
    //=========================================================================================
    /* NOTHING */

public:
    //=========================================================================================
    // public variables.
    //=========================================================================================
    /* NOTHING */

    //=========================================================================================
    // pubic methods.
    //=========================================================================================

    //-----------------------------------------------------------------------------------------
    //! @brief      コンストラクタです.
    //-----------------------------------------------------------------------------------------
    Texture2D();

    //-----------------------------------------------------------------------------------------
    //! @brief      デストラクタです.
    //-----------------------------------------------------------------------------------------
    virtual ~Texture2D();

    //-----------------------------------------------------------------------------------------
    //! @brief      ファイルからテクスチャを生成します.
    //!
    //! @param [in]     pDevice     デバイスです.
    //! @param [in]     filename    テクスチャファイル名です.
    //! @retval true    生成に成功.
    //! @retval false   生成に失敗.
    //-----------------------------------------------------------------------------------------
    bool CreateFromFile( ID3D11Device* pDevice, const char* filename );

    //-----------------------------------------------------------------------------------------
    //! @brief      メモリ解放処理です.
    //-----------------------------------------------------------------------------------------
    void Release();

    //-----------------------------------------------------------------------------------------
    //! @brief      フォーマットを取得します.
    //!
    //! @return     フォーマットを返却します.
    //-----------------------------------------------------------------------------------------
    int GetFormat() const;

    //-----------------------------------------------------------------------------------------
    //! @brief      テクスチャを取得します.
    //!
    //! @return     テクスチャを返却します.
    //-----------------------------------------------------------------------------------------
    ID3D11Texture2D*            GetTexture();

    //-----------------------------------------------------------------------------------------
    //! @brief      シェーダリソースビューを取得します.
    //!
    //! @return     シェーダリソースビューを返却します.
    //-----------------------------------------------------------------------------------------
    ID3D11ShaderResourceView*   GetSRV();

protected:
    //=========================================================================================
    // protected variables
    //=========================================================================================
    int                         m_Format;           //!< フォーマットです.
    ID3D11Texture2D*            m_pTexture;         //!< テクスチャです.
    ID3D11ShaderResourceView*   m_pSRV;             //!< シェーダリソースビューです.

    //=========================================================================================
    // protected methods.
    //=========================================================================================
    /* NOTHING */

private:
    //=========================================================================================
    // private variables.
    //=========================================================================================
    /* NOTHING */

    //=========================================================================================
    // private methods.
    //=========================================================================================
    Texture2D       ( const Texture2D& texture );
    void operator = ( const Texture2D& texture );
};



///////////////////////////////////////////////////////////////////////////////////////////////
// Texture3D class
///////////////////////////////////////////////////////////////////////////////////////////////
class Texture3D
{
    //=========================================================================================
    // list of friend classes and methods.
    //=========================================================================================
    /* NOTHING */

public:
    //=========================================================================================
    // public variables.
    //=========================================================================================
    /* NOTHING */

    //=========================================================================================
    // pubic methods.
    //=========================================================================================

    //-----------------------------------------------------------------------------------------
    //! @brief      コンストラクタです.
    //-----------------------------------------------------------------------------------------
    Texture3D();

    //-----------------------------------------------------------------------------------------
    //! @brief      デストラクタです.
    //-----------------------------------------------------------------------------------------
    virtual ~Texture3D();

    //-----------------------------------------------------------------------------------------
    //! @brief      ファイルからテクスチャを生成します.
    //!
    //! @param [in]     pDevice     デバイスです.
    //! @param [in]     filename    テクスチャファイル名です.
    //! @retval true    生成に成功.
    //! @retval false   生成に失敗.
    //-----------------------------------------------------------------------------------------
    bool CreateFromFile( ID3D11Device* pDevice, const char* filename );

    //-----------------------------------------------------------------------------------------
    //! @brief      メモリ解放処理です.
    //-----------------------------------------------------------------------------------------
    void Release();

    //-----------------------------------------------------------------------------------------
    //! @brief      フォーマットを取得します.
    //!
    //! @return     フォーマットを返却します.
    //-----------------------------------------------------------------------------------------
    int GetFormat() const;

    //-----------------------------------------------------------------------------------------
    //! @brief      テクスチャを取得します.
    //!
    //! @return     テクスチャを返却します.
    //-----------------------------------------------------------------------------------------
    ID3D11Texture3D*            GetTexture();

    //-----------------------------------------------------------------------------------------
    //! @brief      シェーダリソースビューを取得します.
    //!
    //! @return     シェーダリソースビューを返却します.
    //-----------------------------------------------------------------------------------------
    ID3D11ShaderResourceView*   GetSRV();

protected:
    //=========================================================================================
    // protected variables
    //=========================================================================================
    int                         m_Format;           //!< フォーマットです.
    ID3D11Texture3D*            m_pTexture;         //!< テクスチャです.
    ID3D11ShaderResourceView*   m_pSRV;             //!< シェーダリソースビューです.

    //=========================================================================================
    // protected methods.
    //=========================================================================================
    /* NOTHING */

private:
    //=========================================================================================
    // private variables.
    //=========================================================================================
    /* NOTHING */

    //=========================================================================================
    // private methods.
    //=========================================================================================
    Texture3D       ( const Texture3D& texture );
    void operator = ( const Texture3D& texture );
};


} // namespace asdx

#endif//__ASDX_TEXTURE_H__