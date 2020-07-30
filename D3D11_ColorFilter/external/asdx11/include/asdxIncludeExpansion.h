﻿//-----------------------------------------------------------------------------
// File : asdxIncludeExpansion.h
// Desc : Include Expansion
// Copyright(c) Project Asura. All right reserved.
//-----------------------------------------------------------------------------
#pragma once

//-----------------------------------------------------------------------------
// Includes
//-----------------------------------------------------------------------------
#include <vector>
#include <string>


namespace asdx {

///////////////////////////////////////////////////////////////////////////////
// IncludeExpansion class
///////////////////////////////////////////////////////////////////////////////
class IncludeExpansion
{
    //=========================================================================
    // list of friend classes and methods.
    //=========================================================================
    /* NOTHING */

public:
    //=========================================================================
    // public variables.
    //=========================================================================
    /* NOTHING */

    //=========================================================================
    // public methods.
    //=========================================================================

    //-------------------------------------------------------------------------
    //! @brief      コンストラクタです.
    //-------------------------------------------------------------------------
    IncludeExpansion();

    //-------------------------------------------------------------------------
    //! @brief      デストラクタです.
    //-------------------------------------------------------------------------
    ~IncludeExpansion();

    //-------------------------------------------------------------------------
    //! @brief      展開処理を行います.
    //!
    //! @param[in]      filename        対象ファイル.
    //! @param[in]      dirPaths        インクルードディレクトリ.
    //! @retval true    展開に成功.
    //! @retval false   展開に失敗.
    //-------------------------------------------------------------------------
    bool Init(const char* filename, const std::vector<std::string>& dirPaths);

    //-------------------------------------------------------------------------
    //! @brief      終了処理を行います.
    //-------------------------------------------------------------------------
    void Term();

    //-------------------------------------------------------------------------
    //! @brief      展開結果を取得します.
    //!
    //! @return     展開結果を返却します.
    //-------------------------------------------------------------------------
    const std::string& GetExpandResult() const;

private:
    ///////////////////////////////////////////////////////////////////////////
    // Info structure
    ///////////////////////////////////////////////////////////////////////////
    struct Info
    {
        std::string     IncludeFile;    //!< インクルード文
        std::string     FindPath;       //!< 解決済みファイルパス.
        std::string     Code;           //!< 該当ファイル.
    };

    //=========================================================================
    // private variables.
    //=========================================================================
    std::vector<Info>           m_Includes;     //!< インクルード情報.
    std::vector<std::string>    m_DirPaths;     //!< インクルードディレクトリ.
    std::string                 m_Expanded;     //!< 展開結果.

    //=========================================================================
    // private methods.
    //=========================================================================

    //-------------------------------------------------------------------------
    //! @brief      ファイルを読み込みます.
    //-------------------------------------------------------------------------
    bool LoadFile(const char* filename, std::string& result);

    //-------------------------------------------------------------------------
    //! @brief      インクルード情報を収集します.
    //-------------------------------------------------------------------------
    bool CorrectInfo(const char* filename);

    //-------------------------------------------------------------------------
    //! @brief      収集情報を元に展開処理を行います.
    //-------------------------------------------------------------------------
    bool Expand(std::string& inout);

    //-------------------------------------------------------------------------
    //! @brief      文字列を置換します(処理実行判定付き).
    //-------------------------------------------------------------------------
    static std::string Replace(
        const std::string&  input,
        std::string         pattern,
        std::string         replace,
        bool&               hit);

    //-------------------------------------------------------------------------
    //! @brief      文字列を置換します.
    //-------------------------------------------------------------------------
    static std::string Replace(
        const std::string&  input,
        std::string         pattern,
        std::string         replace);
};

} // namespace asdx