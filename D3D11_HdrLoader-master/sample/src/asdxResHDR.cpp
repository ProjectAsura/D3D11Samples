//-------------------------------------------------------------------------------------------------
// File : asdxResHDR.cpp
// Desc : HDR File Format.
// Copyright(c) Project Asura. All right reserved.
//-------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
// Includes
//-------------------------------------------------------------------------------------------------
#include <asdxResHDR.h>
#include <asdxHash.h>
#include <asdxLogger.h>
#include <new>
#include <cstdio>



///////////////////////////////////////////////////////////////////////////////////////////////////
// RGBE structure
///////////////////////////////////////////////////////////////////////////////////////////////////
struct RGBE
{
    union
    {
        struct { u8 r, g, b, e; };
        u8 v[4];
    };
};


namespace /* anonymous */ {

///////////////////////////////////////////////////////////////////////////////////////////////////
// SCANLINE_TYPE
///////////////////////////////////////////////////////////////////////////////////////////////////
enum SCANLINE_TYPE
{
    SCANLINE_NY_PX = 0,     //!< -Y +X
    SCANLINE_NY_NX,         //!< -Y -X
    SCANLINE_PY_PX,         //!< +Y +X
    SCANLINE_PY_NX,         //!< +Y -X
    SCANLINE_NX_PY,         //!< -X +Y
    SCANLINE_NX_NY,         //!< -X -Y
    SCANLINE_PX_PY,         //!< +X +Y
    SCANLINE_PX_NY,         //!< +X -Y
};

//-------------------------------------------------------------------------------------------------
//      CRLF����菜���܂�.
//-------------------------------------------------------------------------------------------------
void RemoveEndline( char* pBuf )
{
    for( auto i = strlen(pBuf) -1; 0 <= i; i-- )
    {
        if ( pBuf[ i ] != '\r' && pBuf[ i ] != '\n')
            break;

        pBuf[ i ] = '\0';
    }
}


//-------------------------------------------------------------------------------------------------
//      ���`���̃J���[��ǂݎ��܂�.
//-------------------------------------------------------------------------------------------------
bool ReadOldColors( FILE* pFile, RGBE* pLine, s32 count )
{
    auto shift = 0;
    while( 0 < count )
    {
        pLine[0].r = getc( pFile );
        pLine[0].g = getc( pFile );
        pLine[0].b = getc( pFile );
        pLine[0].e = getc( pFile );

        if ( feof( pFile ) || ferror( pFile ) )
            return false;

        if ( pLine[0].r == 1
          && pLine[0].g == 1
          && pLine[0].b == 1 )
        {
            for( auto i=pLine[0].e << shift; i > 0; i-- )
            {
                pLine[0].r = pLine[-1].r;
                pLine[0].g = pLine[-1].g;
                pLine[0].b = pLine[-1].b;
                pLine[0].e = pLine[-1].e;
                pLine++;
                count--;
            }
            shift += 8;
        }
        else
        {
            pLine++;
            count--;
            shift = 0;
        }
    }

    return true;
}

//-------------------------------------------------------------------------------------------------
//      �J���[��ǂݎ��܂�.
//-------------------------------------------------------------------------------------------------
bool ReadColor( FILE* pFile, RGBE* pLine, s32 count )
{
    if ( count < 8 || 0x7fff < count )
    { return ReadOldColors( pFile, pLine, count ); }

    auto pHead = pLine;

    auto j = 0;
    auto i = getc( pFile );
    if ( i == EOF )
        return false;

    if ( i != 2 )
    {
        ungetc( i, pFile );
        return ReadOldColors( pFile, pLine, count );
    }

    pLine[0].g = getc( pFile );
    pLine[0].b = getc( pFile );

    if ( ( i = getc( pFile ) ) == EOF )
        return false;

    if ( pLine[0].g != 2 || pLine[0].b & 128 )
    {
        pLine[0].r = 2;
        pLine[0].e = i;
        return ReadOldColors( pFile, pLine + 1, count -1 );
    }

    if ( ( pLine[0].b << 8 | i ) != count )
        return false;

    for( i=0; i<4; ++i )
    {
        for( j=0; j<count; )
        {
            auto code = getc( pFile );
            if ( code == EOF )
                return false;

            if ( 128 < code )
            {
                code &= 127;
                auto val = getc( pFile );
                while( code-- )
                { 
                    pLine[j++].v[i] = val;
                }
            }
            else
            {
                while( code-- )
                { 
                    pLine[j++].v[i] = getc( pFile );
                }
            }
        }
    }

    return ( feof( pFile ) ? false : true );
}


} // namespace /* anonymous */


namespace asdx {

///////////////////////////////////////////////////////////////////////////////////////////////////
// ResHDR class
///////////////////////////////////////////////////////////////////////////////////////////////////

//-------------------------------------------------------------------------------------------------
//      �R���X�g���N�^�ł�.
//-------------------------------------------------------------------------------------------------
ResHDR::ResHDR()
: m_Width   ( 0 )
, m_Height  ( 0 )
, m_Exposure( 1.0f )
, m_Gamma   ( 1.0f )
, m_pPixels ( nullptr )
, m_HashKey ( 0 )
{ /* DO_NOTHING */ }

//-------------------------------------------------------------------------------------------------
//      �R�s�[�R���X�g���N�^�ł�.
//-------------------------------------------------------------------------------------------------
ResHDR::ResHDR( const ResHDR& value )
: m_Width   ( value.m_Width )
, m_Height  ( value.m_Height )
, m_Exposure( value.m_Exposure )
, m_Gamma   ( value.m_Gamma )
, m_pPixels ( nullptr )
, m_HashKey ( value.m_HashKey )
{
    auto size = m_Width * m_Height;
    m_pPixels = new (std::nothrow) RGBE [ size ];
    assert( m_pPixels != nullptr );

    if ( m_pPixels != nullptr )
    { memcpy( m_pPixels, value.m_pPixels, size * sizeof(RGBE) ); }
}

//-------------------------------------------------------------------------------------------------
//      �f�X�g���N�^�ł�.
//-------------------------------------------------------------------------------------------------
ResHDR::~ResHDR()
{ Release(); }

//-------------------------------------------------------------------------------------------------
//      �t�@�C������ǂݍ��݂��܂�.
//-------------------------------------------------------------------------------------------------
bool ResHDR::Load( const char16* filename )
{
    if ( filename == nullptr )
    {
        ELOG( "Error : Invalid Argument." );
        return false;
    }

    FILE* pFile;
    auto err = _wfopen_s( &pFile, filename, L"rb" );
    if ( err != 0 )
    {
        ELOG( "Error : File Open Failed. filename = %s", filename );
        return false;
    }

    const u32 BUFFER_SIZE = 256;
    char buf[ BUFFER_SIZE ];
    fgets( buf, BUFFER_SIZE, pFile );
    RemoveEndline( buf );

    // �}�W�b�N���`�F�b�N.
    if ( strcmp( buf, "#?RADIANCE") != 0 )
    {
        ELOG( "Error : Invalid File." );
        fclose( pFile );
        return false;
    }

    u32 scanlineType = 0;

    while( 1 )
    {
        if ( feof( pFile ) )
        {
             fclose( pFile );
             ELOG( "Error : End Of File.");
             Release();
             return false;
        }

        if ( fgets( buf, BUFFER_SIZE, pFile ) == nullptr )
        {
            fclose( pFile );
            Release();
            return false;
        }

        // CRLF���폜.
        RemoveEndline( buf );

        if ( buf[0] == '#' )
        { 
            continue;
        }
        else if ( buf[0] == 'F' )
        {
            char format[ BUFFER_SIZE ];
            sscanf_s( buf, "FORMAT=%s", format, _countof(format) );

            if ( strcmp( format, "32-bit_rle_rgbe" ) != 0
              && strcmp( format, "32-bit_rle_xyze" ) != 0 )
            {
                fclose( pFile );
                ELOG( "Error : Invalid Format." );
                return false;
            }
        }
        else if ( buf[0] == 'E' )
        {
            sscanf_s( buf, "EXPOSURE=%f", &m_Exposure );
        }
        else if ( buf[0] == 'C' )
        {
            /* COLORCORR �͔�T�|�[�g */
        }
        else if ( buf[0] == 'S' )
        {
            ILOG( "Info : Software = %s", buf );
        }
        else if ( buf[0] == 'P' && buf[1] == 'I' )
        {
            /* PIXASPECT �͔�T�|�[�g */
        }
        else if ( buf[0] == 'V' )
        {
            /* VIEW �͔�T�|�[�g */
        }
        else if ( buf[0] == 'P' && buf[1] == 'R' )
        {
            /* PRIMARIES �͔�T�|�[�g */
        }
        else if ( buf[0] == 'G' )
        {
            sscanf_s( buf, "GAMMA=%f", &m_Gamma );
        }
        else if ( buf[0] == '-' && buf[1] == 'Y' )
        {
            // Y m X n �`���Ȃ̂ŁCn�s�̃f�[�^��m�񕪂���@���ʂ̃e�N�X�`���`��.
            char sig;
            sscanf_s( buf, "-Y %d %cX %d", &m_Height, &sig, 1, &m_Width );
            if ( sig == '+')
            {
                // �e�N�X�`���̃f�[�^��Y�͉��ɐi��ŁCX�͉E�ɐi��.
                scanlineType = SCANLINE_NY_PX;
            }
            else if ( sig == '-')
            {
                // �e�N�X�`���̃f�[�^��Y�͉��ɐi��ŁCX�͍��ɐi��.
                scanlineType = SCANLINE_NY_NX;
            }
            break;
        }
        else if ( buf[0] == '+' && buf[1] == 'Y' )
        {
            // Y m X n �`���Ȃ̂ŁCn�s�̃f�[�^��m�񕪂���@���ʂ̃e�N�X�`���`��.
            char sig;
            sscanf_s( buf, "+Y %d %cX %d", &m_Height, &sig, 1, &m_Width );
            if ( sig == '+' )
            {
                // �e�N�X�`���̃f�[�^��Y�͏�ɐi��ŁCX�͉E�ɐi��.
                scanlineType = SCANLINE_PY_PX;
            }
            else if ( sig == '-' )
            {
                // �e�N�X�`���̃f�[�^��Y�͏�ɐi��ŁCX�͍��ɐi��.
                scanlineType = SCANLINE_PY_NX;
            }
            break;
        }
        else if ( buf[0] == '-' && buf[1] == 'X' )
        {
            // X n Y m �`���Ȃ̂ŁCm��̃f�[�^��n�s������. 90�x��]�����悤�ȃf�[�^.
            char sig;
            sscanf_s( buf, "-X %d %cY %d", &m_Width, &sig, 1, &m_Height );
            if ( sig == '+' )
            {
                // �e�N�X�`���̃f�[�^��X�͍��ɐi��ŁCY�͏�ɐi��.
                scanlineType = SCANLINE_NX_PY;
            }
            else if ( sig == '-' )
            {
                // �e�N�X�`���̃f�[�^��X�͍��ɐi��ŁCY�͉��ɐi��.
                scanlineType = SCANLINE_NX_NY;
            }
            break;
        }
        else if ( buf[0] == '+' && buf[1] == 'X' )
        {
            // X n Y m �`���Ȃ̂ŁCm��̃f�[�^��n�s������. 90�x��]�����悤�ȃf�[�^.

            char sig;
            sscanf_s( buf, "+X %d %cY %d", &m_Width, &sig, 1, &m_Height );
            if ( sig == '+' )
            {
                // �e�N�X�`���̃f�[�^��X�͉E�ɐi��ŁCY�͏�ɐi��.
                scanlineType = SCANLINE_PX_PY;
            }
            else if ( sig == '-' )
            {
                // �e�N�X�`���̃f�[�^��X�͉E�ɐi��ŁCY�͉��ɐi��.
                scanlineType = SCANLINE_PX_NY;
            }
            break;
        }
    }

    if ( scanlineType != SCANLINE_NY_PX &&
         scanlineType != SCANLINE_PY_PX )
    {
        ELOG( "Error : Unsupported Scanline Format" );
        fclose( pFile );
        return false;
    }

    // ��������������Ă���.
    ASDX_DELETE_ARRAY( m_pPixels );

    // ���������m��.
    m_pPixels = new (std::nothrow) RGBE [ m_Width * m_Height ];
    assert( m_pPixels != nullptr );
    if ( m_pPixels == nullptr )
    {
        ELOG( "Error : Out of Memory.");
        fclose( pFile );
        Release();
        return false;
    }

    if ( scanlineType == SCANLINE_NY_PX )
    {
        // Direct3D�̃e�N�X�`�����W�n�ɍ��킹��̂ŁCY�����͋t����ǂݍ���.
        for( int y = (s32)m_Height - 1; y >= 0; y-- )
        {
            if ( !ReadColor( pFile, &m_pPixels[y * m_Width], m_Width ) )
            {
                fclose( pFile );
                Release();
                return false;
            }
        }
    }
    else if ( scanlineType == SCANLINE_PY_PX )
    {
        // Direct3D�̃e�N�X�`�����W�n�ɍ��킹��̂ŁCY�����͋t����ǂݍ���.
        for( int y = 0; y < (s32)m_Height; y++ )
        {
            if ( !ReadColor( pFile, &m_pPixels[y * m_Width], m_Width ) )
            {
                fclose( pFile );
                Release();
                return false;
            }
        }
    }

    m_HashKey = CRC32( filename ).GetHash();

    fclose( pFile );

    return true;
}

//-------------------------------------------------------------------------------------------------
//      ��������������܂�.
//-------------------------------------------------------------------------------------------------
void ResHDR::Release()
{
    ASDX_DELETE_ARRAY( m_pPixels );
    m_Width    = 0;
    m_Height   = 0;
    m_Exposure = 1.0f;
    m_Gamma    = 1.0f;
    m_HashKey  = 0;
}

//-------------------------------------------------------------------------------------------------
//      �摜�̉������擾���܂�.
//-------------------------------------------------------------------------------------------------
const u32 ResHDR::GetWidth() const
{ return m_Width; }

//-------------------------------------------------------------------------------------------------
//      �摜�̏c�����擾���܂�.
//-------------------------------------------------------------------------------------------------
const u32 ResHDR::GetHeight() const
{ return m_Height; }

//-------------------------------------------------------------------------------------------------
//      �I�o�l���擾���܂�.
//-------------------------------------------------------------------------------------------------
const f32 ResHDR::GetExposure() const
{ return m_Exposure; }

//-------------------------------------------------------------------------------------------------
//      RGBE�`���̃s�N�Z���f�[�^���擾���܂�.
//-------------------------------------------------------------------------------------------------
const u8* ResHDR::GetPixels() const
{ return &m_pPixels[0].r; }

//-------------------------------------------------------------------------------------------------
//      �f�R�[�h�����s�N�Z�����擾���܂�.
//-------------------------------------------------------------------------------------------------
void ResHDR::GetFloatPixels( f32** ppPixels ) const
{
    if ( ppPixels == nullptr )
    {
        ELOG( "Error : Invalid Argument." );
        return;
    }

    // RGB�Ȃ̂�3�v�f.
    const auto count = 3;

    // �s�N�Z���T�C�Y.
    auto size = m_Width * m_Height * count;

    // ���������m��.
    auto pPixels = new (std::nothrow) f32 [ size ];
    assert( pPixels != nullptr );

    if ( pPixels == nullptr )
    {
        ELOG( "Error : Out of Memory.");
        return;
    }

    f32 deGamma = 1.0f / m_Gamma;

    for( u32 i=0; i<m_Width*m_Height; ++i )
    {
        if ( m_pPixels[ i ].e )
        {
            // ldexpf( x, exp ) = x * (2 ^ exp).
            auto val = ldexpf( 1.0f, m_pPixels[ i ].e - s32(128+8) );

            // �K���}�␳���Ȃ���i�[.
            pPixels[ i * count + 0 ] = powf( m_pPixels[ i ].r * val, deGamma );
            pPixels[ i * count + 1 ] = powf( m_pPixels[ i ].g * val, deGamma );
            pPixels[ i * count + 2 ] = powf( m_pPixels[ i ].b * val, deGamma );
        }
        else
        {
            pPixels[ i * count + 0 ] = 0.0f;
            pPixels[ i * count + 1 ] = 0.0f;
            pPixels[ i * count + 2 ] = 0.0f;
        }
    }

    (*ppPixels) = pPixels;
}

//-------------------------------------------------------------------------------------------------
//      ������Z�q�ł�.
//-------------------------------------------------------------------------------------------------
ResHDR& ResHDR::operator= ( const ResHDR& value )
{
    m_Width     = value.m_Width;
    m_Height    = value.m_Height;
    m_Exposure  = value.m_Exposure;
    m_Gamma     = value.m_Gamma;
    m_HashKey   = value.m_HashKey;

    ASDX_DELETE_ARRAY( m_pPixels );
    auto size = m_Width * m_Height;
    m_pPixels = new (std::nothrow) RGBE [ size ];
    assert( m_pPixels != nullptr );

    if ( m_pPixels )
    { memcpy( m_pPixels, value.m_pPixels, size * sizeof(RGBE) ); }

    return (*this);
}

//-------------------------------------------------------------------------------------------------
//      ������r���Z�q�ł�.
//-------------------------------------------------------------------------------------------------
bool ResHDR::operator == ( const ResHDR& value ) const
{
    if ( &value == this )
    { return true; }

    return ( m_HashKey == value.m_HashKey );
}

//-------------------------------------------------------------------------------------------------
//      �񓙉���r���Z�q�ł�.
//-------------------------------------------------------------------------------------------------
bool ResHDR::operator!=( const ResHDR& value ) const
{
    if ( &value == this )
    { return false; }

    return ( m_HashKey != value.m_HashKey );
}

} // namespace asdx