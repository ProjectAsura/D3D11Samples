//-----------------------------------------------------------------------------
// File : Math.hlsli
// Desc : Math Utility.
// Copyright(c) Project Asura. All right reserved.
//-----------------------------------------------------------------------------
#ifndef MATH_HLSLI
#define MATH_HLSLI

//-----------------------------------------------------------------------------
// Constant Values.
//-----------------------------------------------------------------------------
static const float HALF_MAX = 65504.0f;         // 半精度浮動小数の最大値.
static const float F_PI     = 3.1415926535897932384626433832795f;
static const float F_1DIVPI = 0.31830988618379067153776752674503f;
static const float F_DITHER_LIST[4][4] = {
        { 0.37647f, 0.87450f, 0.50196f, 0.95000f },
        { 0.62352f, 0.12549f, 0.75294f, 0.25098f },
        { 0.43921f, 0.93725f, 0.31372f, 0.81568f },
        { 0.68627f, 0.18823f, 0.56470f, 0.06274f },
    };


//-----------------------------------------------------------------------------
//      半精度浮動小数の最大値未満に飽和させます.
//-----------------------------------------------------------------------------
float SaturateHalf(float value)
{ return clamp(value, 0.0f, HALF_MAX); }

//-----------------------------------------------------------------------------
//      半精度浮動小数の最大値未満に飽和させます.
//-----------------------------------------------------------------------------
float2 SaturateHalf(float2 value)
{ return clamp(value, float(0).xx, HALF_MAX.xx); }

//-----------------------------------------------------------------------------
//      半精度浮動小数の最大値未満に飽和させます.
//-----------------------------------------------------------------------------
float3 SaturateHalf(float3 value)
{ return clamp(value, float(0).xxx, HALF_MAX.xxx); }

//-----------------------------------------------------------------------------
//      単精度浮動小数の最大値未満に飽和させます.
//-----------------------------------------------------------------------------
float4 SaturateHalf(float4 value)
{ return clamp(value, float(0).xxxx, HALF_MAX.xxxx); }

//-----------------------------------------------------------------------------
//      2乗計算を行います.
//-----------------------------------------------------------------------------
float Sq(float x)
{ return x * x; }

//-----------------------------------------------------------------------------
//      2乗計算を行います.
//-----------------------------------------------------------------------------
float Pow2(float x)
{ return x * x; }

//-----------------------------------------------------------------------------
//      2乗計算を行います.
//-----------------------------------------------------------------------------
float2 Pow2(float2 x)
{ return x * x; }

//-----------------------------------------------------------------------------
//      2乗計算を行います.
//-----------------------------------------------------------------------------
float3 Pow2(float3 x)
{ return x * x; }

//-----------------------------------------------------------------------------
//      2乗計算を行います.
//-----------------------------------------------------------------------------
float4 Pow2(float4 x)
{ return x * x; }

//-----------------------------------------------------------------------------
//      4乗計算を行います.
//-----------------------------------------------------------------------------
float Pow4(float x)
{
    float x2 = x * x;
    return x2 * x2;
}

//-----------------------------------------------------------------------------
//      4乗計算を行います.
//-----------------------------------------------------------------------------
float2 Pow4(float2 x)
{
    float2 x2 = x * x;
    return x2 * x2;
}

//-----------------------------------------------------------------------------
//      4乗計算を行います.
//-----------------------------------------------------------------------------
float3 Pow4(float3 x)
{
    float3 x2 = x * x;
    return x2 * x2;
}

//-----------------------------------------------------------------------------
//      4乗計算を行います.
//-----------------------------------------------------------------------------
float4 Pow4(float4 x)
{
    float4 x2 = x * x;
    return x2 * x2;
}

//-----------------------------------------------------------------------------
//      5乗計算を行います.
//-----------------------------------------------------------------------------
float Pow5(float x)
{
    float x2 = x * x;
    return x2 * x2 * x;
}

//-----------------------------------------------------------------------------
//      5乗計算を行います.
//-----------------------------------------------------------------------------
float2 Pow5(float2 x)
{
    float2 x2 = x * x;
    return x2 * x2 * x;
}

//-----------------------------------------------------------------------------
//      5乗計算を行います.
//-----------------------------------------------------------------------------
float3 Pow5(float3 x)
{
    float3 x2 = x * x;
    return x2 * x2 * x;
}

//-----------------------------------------------------------------------------
//      5乗計算を行います.
//-----------------------------------------------------------------------------
float4 Pow5(float4 x)
{
    float4 x2 = x * x;
    return x2 * x2 * x;
}

//-----------------------------------------------------------------------------
//      累乗計算を行います.
//-----------------------------------------------------------------------------
float Pow(float a, float b)
{
    // a == 0.0f && b == 0.0f のときに機種依存によりNaNが発生する恐れがあるので，
    // 発生しないようにクランプ処理を入れる.
    return pow(max(abs(a), 1e-6f), b);
}

//-----------------------------------------------------------------------------
//      累乗計算を行います.
//-----------------------------------------------------------------------------
float2 Pow(float2 a, float2 b)
{
    // a == 0.0f && b == 0.0f のときに機種依存によりNaNが発生する恐れがあるので，
    // 発生しないようにクランプ処理を入れる.
    return pow(max(abs(a), float(1e-6f).xx), b);
}

//-----------------------------------------------------------------------------
//      累乗計算を行います.
//-----------------------------------------------------------------------------
float3 Pow(float3 a, float3 b)
{
    // a == 0.0f && b == 0.0f のときに機種依存によりNaNが発生する恐れがあるので，
    // 発生しないようにクランプ処理を入れる.
    return pow(max(abs(a), float(1e-6f).xxx), b);
}

//-----------------------------------------------------------------------------
//      累乗計算を行います.
//-----------------------------------------------------------------------------
float4 Pow(float4 a, float4 b)
{
    // a == 0.0f && b == 0.0f のときに機種依存によりNaNが発生する恐れがあるので，
    // 発生しないようにクランプ処理を入れる.
    return pow(max(abs(a), float(1e-6f).xxxx), b);
}

//-----------------------------------------------------------------------------
//      再マッピングします.
//-----------------------------------------------------------------------------
float Remap(float value, float oldMin, float oldMax, float newMin, float newMax)
{ return clamp((value - oldMin) * ((newMax - newMin) / (oldMax - oldMin)) + newMin, newMin, newMax); }

//-----------------------------------------------------------------------------
//      再マッピングします.
//-----------------------------------------------------------------------------
float2 Remap(float2 value, float2 oldMin, float2 oldMax, float2 newMin, float2 newMax)
{ return clamp((value - oldMin) * ((newMax - newMin) / (oldMax - oldMin)) + newMin, newMin, newMax); }

//-----------------------------------------------------------------------------
//      再マッピングします.
//-----------------------------------------------------------------------------
float3 Remap(float3 value, float3 oldMin, float3 oldMax, float3 newMin, float3 newMax)
{ return clamp((value - oldMin) * ((newMax - newMin) / (oldMax - oldMin)) + newMin, newMin, newMax); }

//-----------------------------------------------------------------------------
//      再マッピングします.
//-----------------------------------------------------------------------------
float4 Remap(float4 value, float4 oldMin, float4 oldMax, float4 newMin, float4 newMax)
{ return clamp((value - oldMin) * ((newMax - newMin) / (oldMax - oldMin)) + newMin, newMin, newMax); }

//-----------------------------------------------------------------------------
//      最大コンポーネントの値を取得します.
//-----------------------------------------------------------------------------
float Max3(float3 value)
{ return max(value.x, max(value.y, value.z)); }

//-----------------------------------------------------------------------------
//      最大コンポーネントの値を取得します.
//-----------------------------------------------------------------------------
float Max4(float4 value)
{ return max(value.x, max(value.y, max(value.z, value.w))); }

//-----------------------------------------------------------------------------
//      最小コンポーネントの値を取得します.
//-----------------------------------------------------------------------------
float Min3(float3 value)
{ return min(value.x, min(value.y, value.z)); }

//-----------------------------------------------------------------------------
//      最小コンポーネントの値を取得します.
//-----------------------------------------------------------------------------
float Min4(float4 value)
{ return min(value.x, min(value.y, min(value.z, value.w))); }

//-----------------------------------------------------------------------------
//      RGBE形式に圧縮します.
//-----------------------------------------------------------------------------
float4 EncodeHDR(float3 value)
{
    value = 65536.0f;
    float3 exponent  = clamp(ceil(log2(value)), -128.0f, 127.0f);
    float  component = Max3(exponent);
    float  range     = exp2(component);
    float3 mantissa  = saturate(value / range);
    return float4(mantissa, (component + 128.0f) / 256.0f);
}

//-----------------------------------------------------------------------------
//      RGBE形式を展開します.
//-----------------------------------------------------------------------------
float3 DecodeHDR(float4 value)
{
    float  exponent = value.a * 256.0f - 128.0f;
    float3 mantissa = value.rgb;
    return exp2(exponent) * mantissa * 65536.0f;
}

//-----------------------------------------------------------------------------
//      接線空間からワールド空間に変換します.
//-----------------------------------------------------------------------------
float3 FromTangentSpaceToWorld(float3 value, float3 T, float3 B, float3 N)
{ return normalize(value.x * T + value.y * B + value.z * N); }

//-----------------------------------------------------------------------------
//      八面体ラップ処理を行います.
//-----------------------------------------------------------------------------
float2 OctWrap(float2 v)
{ return (1.0f - abs(v.yx)) * (v.xy >= 0.0f ? 1.0f : -1.0f); }

//-----------------------------------------------------------------------------
//      法線ベクトルをパッキングします.
//-----------------------------------------------------------------------------
float2 PackNormal(float3 normal)
{
    // Octahedron normal vector encoding.
    // https://knarkowicz.wordpress.com/2014/04/16/octahedron-normal-vector-encoding/
    float3 n = normal / (abs(normal.x) + abs(normal.y) + abs(normal.z));
    n.xy = (n.z >= 0.0f) ? n.xy : OctWrap(n.xy);
    return n.xy * 0.5f + 0.5f;
}

//-----------------------------------------------------------------------------
//      法線ベクトルをアンパッキングします.
//-----------------------------------------------------------------------------
float3 UnpackNormal(float2 packed)
{
    // Octahedron normal vector encoding.
    // https://knarkowicz.wordpress.com/2014/04/16/octahedron-normal-vector-encoding/
    float2 encoded = packed * 2.0f - 1.0f;
    float3 n = float3(encoded.x, encoded.y, 1.0f - abs(encoded.x) - abs(encoded.y));
    float  t = saturate(-n.z);
    n.xy += (n.xy >= 0.0f) ? -t : t;
    return normalize(n);
}

//-----------------------------------------------------------------------------
//      ハードウェアから出力された非線形深度を線形深度に変換します.
//-----------------------------------------------------------------------------
float ToLinearDepth(float hardware_depth, float near_clip, float far_clip)
{ return near_clip / (hardware_depth * (near_clip - far_clip) + far_clip); }

//-----------------------------------------------------------------------------
//      far_clip=∞とする射影行列でハードウェアから出力された非線形深度をビュー空間深度に変換します.
//-----------------------------------------------------------------------------
float ToViewDepth(float hardware_depth, float near_clip)
{ return near_clip / (hardware_depth - 1.0f); }

//-----------------------------------------------------------------------------
//      far_clip=∞とするReverse-Z射影行列でハードウェアから出力された非線形深度をビュー空間深度に変換します.
//-----------------------------------------------------------------------------
float ToViewDepthFromReverseZ(float hardware_depth, float near_clip)
{ return -near_clip / hardware_depth; }

//-----------------------------------------------------------------------------
//      UVからビュー空間位置を求めます.
//-----------------------------------------------------------------------------
float3 UVToViewPos(float2 uv, float linear_depth, float3 param)
{
     // paramはCPU側で以下を計算して渡されたものです.
     // param.z = far_clip;
     // param.y = param.z / proj._22;
     // param.x = param.y * proj._22 / proj._11;
     // ※ proj._22 = 1.0f / tanf(fovy * 0.5f);
     // ※ proj._11 = 1.0f / (tanf(fovy * 0.5f) * aspectRatio);
     float2 st = uv * float2(2.0f, -2.0f) - float2(1.0f, -1.0f);
     float3 view_dir = float3(st.x * param.x, st.y * param.y, -param.z);
     return linear_depth * view_dir;
}

//-----------------------------------------------------------------------------
//      UVとビュー空間深度からビュー空間位置を求めます.
//-----------------------------------------------------------------------------
float3 UVToViewPos(float2 uv, float view_depth, float2 param)
{
    // param.y = 1.0f / proj._22;
    // param.x = 1.0f / proj._11;
    // ※ proj._22 = 1.0f / tanf(fovy * 0.5f);
    // ※ proj._11 = 1.0f / (tanf(fovy * 0.5f) * aspectRatio);
    float2 st = uv * float2(2.0f, -2.0f) - float2(1.0f, -1.0f);
    float3 view_dir = float3(st.x * param.x, st.y * param.y, -1.0f);
    return view_depth * view_dir;
}

//-----------------------------------------------------------------------------
//      最小となる差分値を求めます.
//-----------------------------------------------------------------------------
float3 MinDiff(float3 p, float3 r, float3 l)
{
    float3 v1 = r - p;
    float3 v2 = p - l;
    return (dot(v1, v1) < dot(v2, v2)) ? v1 : v2;
}

//-----------------------------------------------------------------------------
//      法線ベクトルを再構築します.
//-----------------------------------------------------------------------------
float3 ToNormal(float3 p0, float3 pr, float3 pl, float3 pt, float3 pb)
{ 
    // p0 : 中心位置.
    // pr : p0 + (1, 0);
    // pl : p0 - (1, 0);
    // pt : p0 + (0, 1);
    // pb : p0 - (0, 1);
    return normalize(cross(MinDiff(p0, pr, pl), MinDiff(p0, pt, pb)));
}

//-----------------------------------------------------------------------------
//      接線空間を圧縮します.
//      ※データを格納する際は DXGI_FORMAT_R10G10B10A2_UINTを使用してください.
//-----------------------------------------------------------------------------
uint4 EncodeTBN
(
    in float3   normal,                 // 法線ベクトル.
    in float3   tangent,                // 接線ベクトル.
    in uint     binomralHandedeness     // 従法線の向き(通常は1，向きを逆にしたい場合は0).
)
{
    // octahedron normal vector encoding
    uint2 encodedNormal = uint2(PackNormal(normal) * 1023.0f);

    // find largest component of tangent
    float3 tangentAbs = abs(tangent);
    float  maxComp    = Max3(tangentAbs);

    float3 refVector;
    uint   compIndex;
    if (maxComp == tangentAbs.x)
    {
        refVector = float3(1.0f, 0.0f, 0.0f);
        compIndex = 0;
    }
    else if (maxComp == tangentAbs.y)
    {
        refVector = float3(0.0f, 1.0f, 0.0f);
        compIndex = 1;
    }
    else
    {
        refVector = float3(0.0f, 0.0f, 1.0f);
        compIndex = 2;
    }

    // compute cosAngle and handedness of tangent.
    float3 orthoA = normalize(cross(normal, refVector));
    float3 orthoB = cross(normal, orthoA);
    uint cosAngle = uint((dot(tangent, orthoA) * 0.5f + 0.5f) * 255.0f);
    uint tangentHandedness = (dot(tangent, orthoB) > 0.0001f) ? 2 : 0;

    return uint4(encodedNormal, (cosAngle << 2u) | compIndex, tangentHandedness | binomralHandedeness);
}

//-----------------------------------------------------------------------------
//      圧縮した接線空間を展開します.
//      ※入力データはDXGI_FORMAT_R10G10B10A2_UINTに格納されているものとします.
//-----------------------------------------------------------------------------
void DecodeTBN
(
    in  uint4   encodedTBN,     // 圧縮している接線空間.
    out float3  normal,         // 法線ベクトル.
    out float3  tangent,        // 接線ベクトル.
    out float3  binormal        // 従法線ベクトル.
)
{
    // octahedron normal vector decoding.
    normal = UnpackNormal(encodedTBN.xy / 1023.0f);

    // get reference vector
    float3 refVector;
    uint compIndex = (encodedTBN.z & 0x3);
    if (compIndex == 0)
    {
        refVector = float3(1.0f, 0.0f, 0.0f);
    }
    else if (compIndex == 1)
    {
        refVector = float3(0.0f, 1.0f, 0.0f);
    }
    else
    {
        refVector = float3(0.0f, 0.0f, 1.0f);
    }

    // decode tangent
    uint cosAngleUint = ((encodedTBN.z >> 2u) & 0xff);
    float cosAngle = (cosAngleUint / 255.0f) * 2.0f - 1.0f;
    float sinAngle = sqrt(saturate(1.0f - (cosAngle * cosAngle)));

    sinAngle = ((encodedTBN.w & 0x2) == 0) ? -sinAngle : sinAngle;
    float3 orthoA = normalize(cross(normal, refVector));
    float3 orthoB = cross(normal, orthoA);
    tangent = (cosAngle * orthoA) + (sinAngle * orthoB);

    // decode binormal
    binormal = cross(normal, tangent);
    binormal = ((encodedTBN.w & 0x1) == 0) ? binormal : -binormal;
}

//-----------------------------------------------------------------------------
//      浮動小数を8bitデータに変換します.
//-----------------------------------------------------------------------------
uint ToUint8(float value)
{ return clamp(uint(value * 255.0f + 0.5f), 0, 255); }

//-----------------------------------------------------------------------------
//      8bitデータを浮動小数を変換します.
//-----------------------------------------------------------------------------
float FromUint8(uint value)
{ return saturate(float(value) / 255.0f); }

//-----------------------------------------------------------------------------
//      浮動小数2個を16ビットデータに変換します.
//-----------------------------------------------------------------------------
uint ToUint8x2(float value0, float value1)
{
    uint hi = ToUint8(value0);
    uint lo = ToUint8(value1);
    return (hi << 8 | lo);
}

//-----------------------------------------------------------------------------
//      上位8ビットにデータをシフトします.
//-----------------------------------------------------------------------------
uint ToUint8Hi(float value)
{ return ToUint8(value) << 8; }

//-----------------------------------------------------------------------------
//      16ビットデータを浮動小数2個に変換します.
//-----------------------------------------------------------------------------
float2 FromUint8x2(uint value)
{
    float hi = FromUint8((value >> 8) & 0xff);
    float lo = FromUint8((value) & 0xff);
    return float2(hi, lo);
}

//-----------------------------------------------------------------------------
//      16ビットデータの上位8ビットを浮動小数に変換します.
//-----------------------------------------------------------------------------
float FromUint8Hi(uint value)
{ return FromUint8((value >> 8) & 0xff); }

//-----------------------------------------------------------------------------
//      16ビットデータの下位8ビットを浮動小数に変換します.
//-----------------------------------------------------------------------------
float FromUint8Low(uint value)
{ return FromUint8((value) & 0xff); }

//-----------------------------------------------------------------------------
//      Hammersleyサンプリング.
//-----------------------------------------------------------------------------
float2 Hammersley(uint i, uint N)
{
    // Shader Model 5以上が必要.
    float ri = reversebits(i) * 2.3283064365386963e-10f;
    return float2(float(i) / float(N), ri);
//#if 0
//    // Shader Model 5未満.
//    uint bits = (bits << 16u) | (bits >> 16u);
//    uint bits = ((bits & 0x55555555u) << 1u) | ((bits & 0xAAAAAAAAu) >> 1u);
//    uint bits = ((bits & 0x33333333u) << 2u) | ((bits & 0xCCCCCCCCu) >> 2u);
//    uint bits = ((bits & 0x0F0F0F0Fu) << 4u) | ((bits & 0xF0F0F0F0u) >> 4u);
//    uint bits = ((bits & 0x00FF00FFu) << 8u) | ((bits & 0xFF00FF00u) >> 8u);
//    float ri = float(bits) * 2.3283064365386963e-10f;
//    return float2(float(i) / float(N), ri);
//#endif
}

//-----------------------------------------------------------------------------
//      法線マップを合成します.
//-----------------------------------------------------------------------------
float3 BlendNormal(float3 n1, float3 n2)
{
    float3 t = n1 * float3( 2.0f,  2.0f, 2.0f) + float3(-1.0f, -1.0f,  0.0f);
    float3 u = n2 * float3(-2.0f, -2.0f, 2.0f) + float3( 1.0f,  1.0f, -1.0f);
    float3 r = t * dot(t, u) - u * t.z;
    return normalize(r);
}

//-----------------------------------------------------------------------------
//      ベント反射ベクトルを計算します.
//-----------------------------------------------------------------------------
float3 BentReflection(float3 T, float3 B, float3 N, float3 V, float anisotropy)
{
    float3 anisotropicDirection = (anisotropy >= 0.0) ? B : T;
    float3 anisotropicTangent   = cross(anisotropicDirection, V);
    float3 anisotropicNormal    = cross(anisotropicTangent, anisotropicDirection);
    float3 bentNormal           = normalize(lerp(N, anisotropicNormal, anisotropy));
    return reflect(V, bentNormal);
}

//-----------------------------------------------------------------------------
//      余弦の値から正弦を求めます.
//-----------------------------------------------------------------------------
float ToSin(float cosine)
{ return sqrt(1.0f - cosine * cosine); }

//-----------------------------------------------------------------------------
//      接線をシフトします.
//-----------------------------------------------------------------------------
float3 ShiftTangent(float3 T, float3 N, float shiftAngle)
{
    // ShaderX 3の式ではなく，数学的に正しく回転を扱う式に変更.
    float cosTX = cos(shiftAngle);
    float sinTX = sqrt(1.0f - cosTX * cosTX);
    float cosTN = dot(T, N);
    float sinTN = sqrt(1.0f - cosTN * cosTN);
    float3 X = (cosTX * sinTN - cosTN * sinTX) * T + sinTN * sinTX * N;
    return normalize(X);
}

//-----------------------------------------------------------------------------
//      疑似油膜表現.
//-----------------------------------------------------------------------------
float3 FakeFilm(float3 V, float3 N, float mask, float thickness, float ior)
{
    // 高木康行, "モンスターハンター：ワールド アーティストによるシェーダ作成", CEDEC 2018.
    float cos0 = abs(dot(V, N));

    cos0 *= mask;
    float  tr = cos0 * thickness - ior;
    float3 n_color = (cos((tr * 35.0) * float3(0.71,0.87,1.0)) * -0.5) + 0.5;
    n_color = lerp(n_color, float3(0.5, 0.5, 0.5), tr);
    n_color *= n_color*2.0f;
    return n_color;
}

//-----------------------------------------------------------------------------
//      ヒートマップの色を取得します.
//-----------------------------------------------------------------------------
float3 HeatMap(float v) 
{
    float3 r = v * 2.1f - float3(1.8f, 1.14f, 0.3f);
    return 1.0f - r * r;
}

//-----------------------------------------------------------------------------
//      三角ノイズを計算します.
//-----------------------------------------------------------------------------
float TriangleNoise(float2 n, float time)
{
    // triangle noise, in [-1.0..1.0[ range
    float v = 0.07 * frac(time);
    n += float2(v, v);
    n  = frac(n * float2(5.3987, 5.4421));
    n += dot(n.yx, n.xy + float2(21.5351, 14.3137));

    float xy = n.x * n.y;
    // compute in [0..2[ and remap to [-1.0..1.0[
    return frac(xy * 95.4307) + frac(xy * 75.04961) - 1.0;
}

//-----------------------------------------------------------------------------
//      グラディエントノイズを計算します.
//-----------------------------------------------------------------------------
float InterleavedGradientNoise(const float2 n)
{ return frac(52.982919 * frac(dot(float2(0.06711, 0.00584), n))); }

//-----------------------------------------------------------------------------
//      Jimenezによるディザーを計算します.
//-----------------------------------------------------------------------------
float4 DitherJimenez(float2 uv, float time, float4 rgba)
{
    // Jimenez 2014, "Next Generation Post-Processing in Call of Duty"
    float noise = InterleavedGradientNoise(uv.xy + time);
    // remap from [0..1[ to [-1..1[
    noise = (noise * 2.0) - 1.0;
    return float4(rgba.rgb + noise / 255.0, rgba.a);
}

//------------------------------------------------------------------------------
//      Gjølによるディザーを計算します.
//------------------------------------------------------------------------------
float4 DitherTriangleNoise(float4 rgba, float2 uv, float2 screenSize, float time)
{
    // Gjøl 2016, "Banding in Games: A Noisy Rant"
    return rgba + TriangleNoise(uv * screenSize, time) / 255.0;
}

//-----------------------------------------------------------------------------
//      GjølによるRGBディザーを計算します.
//-----------------------------------------------------------------------------
float4 DitherTriangleNoiseRGB(float4 rgba, float2 uv, float2 screenSize, float time)
{
    // Gjøl 2016, "Banding in Games: A Noisy Rant"
    float2 st = uv * screenSize;
    float3 dither = float3(
            TriangleNoise(st, time),
            TriangleNoise(st + 0.1337, time),
            TriangleNoise(st + 0.3141, time)) / 255.0;
    return float4(rgba.rgb + dither, rgba.a + dither.x);
}

//-----------------------------------------------------------------------------
//      球面調和関数の係数ベクトルから放射照度を求めます.
//-----------------------------------------------------------------------------
float3 IrraidanceSH2(float3 n, float4 sh[4])
{
    // 2-Band.
    float3 result = sh[0].rgb
        + sh[1].rgb * (n.y)
        + sh[2].rgb * (n.z)
        + sh[3].rgb * (n.x);
    return max(result, 0.0f);
}

//-----------------------------------------------------------------------------
//      球面調和関数の係数ベクトルから放射照度を求めます.
//-----------------------------------------------------------------------------
float3 IrradianceSH3(float3 n, float4 sh[9])
{
    // 3-Band.
    float3 result = sh[0].rgb
         + sh[1].rgb * (n.y)
         + sh[2].rgb * (n.z)
         + sh[3].rgb * (n.x)
         + sh[4].rgb * (n.y * n.x)
         + sh[5].rgb * (n.y * n.z)
         + sh[6].rgb * (3.0f * n.z * n.z - 1.0f)
         + sh[7].rgb * (n.z * n.x)
         + sh[8].rgb * (n.x * n.x - n.y * n.y);
    return max(result, 0.0f);
}

//-----------------------------------------------------------------------------
//      接線を再計算します.
//-----------------------------------------------------------------------------
float3 RecalcTangent(float3 normalMappedN, float3 T)
{
    // Johon Isidoro, Chris Brenman, "Per-Pixel Strand Based Anisotropic Lighting",
    // Direct3D ShaderX Vertex and Pixel Shader Tips and Tricks, pp.376-382, Wordware Publishing Inc.
    return normalize(T - dot(T, normalMappedN) * normalMappedN);
}

//-----------------------------------------------------------------------------
//      疑似乱数を生成します.
//-----------------------------------------------------------------------------
float Random(float2 value)
{ return frac(sin(dot(value.xy, float2(12.9898, 78.233))) * 43758.5453); }

float GoldNoise(float2 value, float time)
{
    const float F_PHI    = 1.61803398874989484820459 * 0.1;
    const float F_SQ2    = 1.41421356237309504880169 * 10000.0;

    return frac(tan(distance(value * (time + F_PHI), float2(F_PHI, F_PI))) * F_SQ2);
}

float InvErrorFunction(float x)
{
    float y = log(1.0f - x * x);
    float z = 2.0f / (F_PI * 0.14f);
    return sqrt(sqrt(z * z - y * 1.0f / 0.14f) - z) * sign(x);
}

float GaussianNoise(float2 value, float time)
{
    float t = frac(time);
    float x = Random(value + 0.07f * t);
    return InvErrorFunction(x * 2.0f - 1.0f) * 0.15f + 0.5f;
}

float ValueNoise(float2 p)
{
    float2 i = floor(p);
    float2 f = frac(p);
    
    float2 s = smoothstep(0.0, 1.0, f);
    float nx0 = lerp(Random(i + float2(0.0, 0.0)), Random(i + float2(1.0, 0.0)), s.x);
    float nx1 = lerp(Random(i + float2(0.0, 1.0)), Random(i + float2(1.0, 1.0)), s.x);
    return lerp(nx0, nx1, s.y);
}

float BitsTo01(uint bits)
{
    uint div = 0xffffffff;
    return bits * (1.0 / float(div));
}

uint Rotl32(uint var, uint hops)
{
    return (var << hops) | (var >> (32 - hops));
}

void Bjmix(inout uint a, inout uint b, inout uint c)
{
    a -= c;  a ^= Rotl32(c, 4);  c += b;
    b -= a;  b ^= Rotl32(a, 6);  a += c;
    c -= b;  c ^= Rotl32(b, 8);  b += a;
    a -= c;  a ^= Rotl32(c, 16);  c += b;
    b -= a;  b ^= Rotl32(a, 19);  a += c;
    c -= b;  c ^= Rotl32(b, 4);  b += a;
}

uint Bjfinal(uint a, uint b, uint c)
{
    c ^= b; c -= Rotl32(b, 14);
    a ^= c; a -= Rotl32(c, 11);
    b ^= a; b -= Rotl32(a, 25);
    c ^= b; c -= Rotl32(b, 16);
    a ^= c; a -= Rotl32(c, 4);
    b ^= a; b -= Rotl32(a, 14);
    c ^= b; c -= Rotl32(b, 24);
    return c;
}

uint Inthash(uint4 k)
{
    int N = 4;

    uint len = N;
    uint a = 0xdeadbeef + (len << 2) + 13;
    uint b = 0xdeadbeef + (len << 2) + 13;
    uint c = 0xdeadbeef + (len << 2) + 13;

    a += k[0];
    b += k[1];
    c += k[2];
    Bjmix(a, b, c);

    a += k[3];
    c = Bjfinal(a, b, c);

    return c;
}

float3 Hash3(uint4 k)
{
    int N = 4;
    float3 result;
    k[N - 1] = 0;   result.x = BitsTo01(Inthash(k));
    k[N - 1] = 1;   result.y = BitsTo01(Inthash(k));
    k[N - 1] = 2;   result.z = BitsTo01(Inthash(k));
    return result;
}

float3 CellNoise(float3 p)
{
    uint4 iv;
    iv[0] = uint(floor(p.x));
    iv[1] = uint(floor(p.y));
    iv[2] = uint(floor(p.z));
    return Hash3(iv);
}

//-----------------------------------------------------------------------------
//      フレーク法線を生成します.
//-----------------------------------------------------------------------------
void Flakes
(
    float2      uv,
    float       scale,
    float       variance,
    float       size,
    float       orientation,
    out float3  normal,
    out float   alpha
)
{
    float safe_flake_size_variance = clamp(variance, 0.1, 1.0);

    const float3 cellCenters[9] = {
        float3( 0.5,  0.5, 0.0),
        float3( 1.5,  0.5, 0.0),
        float3( 1.5,  1.5, 0.0),
        float3( 0.5,  1.5, 0.0),
        float3(-0.5,  1.5, 0.0),
        float3(-0.5,  0.5, 0.0),
        float3(-0.5, -0.5, 0.0),
        float3( 0.5, -0.5, 0.0),
        float3( 1.5, -0.5, 0.0)
    };

    float3 position = float3(uv, 0.0);
    position = scale * position;

    float3 base = floor(position);

    float3 nearestCell = float3(0.0, 0.0, 1.0);
    int nearestCellIndex = -1;

    [unroll]
    for (int i = 0; i < 9; ++i)
    {
        float3 cellCenter = base + cellCenters[i];

        float3 centerOffset = CellNoise(cellCenter) * 2.0 - 1.0;
        centerOffset[2] *= safe_flake_size_variance;
        centerOffset = normalize(centerOffset);

        cellCenter += 0.5 * centerOffset;
        float cellDistance = distance(position, cellCenter);

        if (cellDistance < size && cellCenter[2] < nearestCell[2])
        {
            nearestCell = cellCenter;
            nearestCellIndex = i;
        }
    }

    normal = float3(0.5, 0.5, 1.0);
    alpha  = 0.0;

    float3 I = float3(0, 0, 1);

    if (nearestCellIndex != -1)
    {
        float3 randomNormal = CellNoise(base + cellCenters[nearestCellIndex] + float3(0.0, 0.0, 1.5));
        randomNormal = 2.0 * randomNormal - 1.0;
        randomNormal = faceforward(randomNormal, I, randomNormal);
        randomNormal = normalize(lerp(randomNormal, float3(0.0, 0.0, 1.0), orientation));

        normal = float3(0.5 * randomNormal[0] + 0.5, -0.5 * randomNormal[1] + 0.5, randomNormal[2]);
        alpha  = 1.0;
    }
}

float Overlay(float v0, float v1)
{ return v0 * (v0 + 2.f * v1 * (1.f - v0)); }

float3 Overlay(float3 v0, float3 v1)
{ return v0 * (v0 + 2.f.xxx * v1 * (1.f.xxx - v0)); }

//-----------------------------------------------------------------------------
//      3要素の合計を求めます.
//-----------------------------------------------------------------------------
float Sum(float3 v)
{ return v.x + v.y + v.z; }

//-----------------------------------------------------------------------------
//      4要素の合計を求めます.
//-----------------------------------------------------------------------------
float Sum(float4 v)
{ return v.x + v.y + v.z + v.w; }

//-----------------------------------------------------------------------------
//      リピートが目立たないようにテクスチャをサンプリングします.
//-----------------------------------------------------------------------------
float4 TextureNoTile
(
    Texture2D       colorMap,
    SamplerState    colorSmp,
    Texture2D       randomMap,
    SamplerState    randomSmp,
    float2          uv, 
    float           v
)
{
    // http://www.iquilezles.org/www/articles/texturerepetition/texturerepetition.htm

    float k = randomMap.Sample(randomSmp, 0.005 * uv).x; // cheap (cache friendly) lookup

    float2 duvdx = ddx(uv);
    float2 duvdy = ddy(uv);
 
    float l = k * 16.0;
    float i = floor( l );
    float f = frac( l );

    float2 offa = sin(float2(7.0f, 5.0f) * (i + 0.0)); // can replace with any other hash
    float2 offb = sin(float2(7.0f, 5.0f) * (i + 1.0)); // can replace with any other hash

    float4 cola = colorMap.SampleGrad(colorSmp, uv + v * offa, duvdx, duvdy );
    float4 colb = colorMap.SampleGrad(colorSmp, uv + v * offb, duvdx, duvdy );

    return lerp( cola, colb, smoothstep(0.2, 0.8, f - 0.1 * Sum(cola - colb)) );
}

//-----------------------------------------------------------------------------
//      UVアニメーションを行います.
//-----------------------------------------------------------------------------
float2 UVAnimation(float2 uv, float2 scale, float2 offset, float rotate)
{
    float2 st = uv * scale;
    float s, c;
    sincos(rotate, s, c);

    float2 temp = st;
    st.x = temp.x * c - temp.y * s;
    st.y = temp.x * s + temp.y * c;
    st += offset;
    return st;
}

//-----------------------------------------------------------------------------
//        Toksvigフィルタを適用します.
//-----------------------------------------------------------------------------
float ToksvigRoughness(float3 normal, float roughness)
{
    float length_normal = length(normal);
    float shininess     = 1.0f - roughness;
    float toksvig_shininess = length_normal * shininess / (length_normal + shininess * (1.0f - length_normal));
    return 1.0f - toksvig_shininess;
}

//-----------------------------------------------------------------------------
//      Toku-Kaplanyanフィルタを適用します.
//-----------------------------------------------------------------------------
float TokuyoshiRoughness(float3 normal, float roughness, float sigma2, float kappa)
{
    // Yusuke Tokuyoshi and Anton S. Kaplanyan, "Improved Geometric Specular Antialiasing",
    // ACM SIGGRAPH Symposium on Interactive 3D Graphics and Games 2019, 
    // sigma2 : screen-space variance.
    // kappa  : clamping threshold.
    // ※ sigma^2 = 0.25, kappa = 0.18 in the paper.
    float3 dndu = ddx(normal);
    float3 dndv = ddy(normal);
    float  variance = sigma2 * (dot(dndu, dndu) + dot(dndv, dndv));
    float  kernelRoughness2 = min(2.0f * variance, kappa);
    return sqrt(saturate(roughness * roughness + kernelRoughness2));
}

//-----------------------------------------------------------------------------
//      リニアからSRGBへの変換.
//-----------------------------------------------------------------------------
float3 Linear_To_SRGB(float3 color)
{
    float3 result;
    result.x  = (color.x < 0.0031308) ? 12.92 : 1.055 * pow(abs(color.x), 1.0f / 2.4) - 0.05f;
    result.y  = (color.y < 0.0031308) ? 12.92 : 1.055 * pow(abs(color.y), 1.0f / 2.4) - 0.05f;
    result.z  = (color.z < 0.0031308) ? 12.92 : 1.055 * pow(abs(color.z), 1.0f / 2.4) - 0.05f;

    return result;
}

//-----------------------------------------------------------------------------
//      SRGBからリニアへの変換.
//-----------------------------------------------------------------------------
float3 SRGB_To_Linear(float3 color)
{
    float3 result;
    result.x = (color.x < 0.0405f) ? color.x / 12.92f : pow((abs(color.x) + 0.055) / 1.055f, 2.4f);
    result.y = (color.y < 0.0405f) ? color.y / 12.92f : pow((abs(color.y) + 0.055) / 1.055f, 2.4f);
    result.z = (color.z < 0.0405f) ? color.z / 12.92f : pow((abs(color.z) + 0.055) / 1.055f, 2.4f);
    
    return result;
}

//------------------------------------------------------------------------------
//      BT.601における輝度値を求める.
//------------------------------------------------------------------------------
float BT601_Luminance(float3 rgb)
{
    const float3 c = float3(0.299f, 0.587f, 0.114f);
    return dot(rgb, c);
}

//-----------------------------------------------------------------------------
//      BT.709における輝度値を求める.
//-----------------------------------------------------------------------------
float BT709_Luminance(float3 rgb)
{
    const float3 c = float3(0.2126f, 0.7152f, 0.0722f);
    return dot(rgb, c);
}

//-----------------------------------------------------------------------------
//      BT.2020における輝度値を求める.
//-----------------------------------------------------------------------------
float BT2020_Luminance(float3 rgb)
{
    const float3 c = float3(0.2627f, 0.6780f, 0.0593f);
    return dot(rgb, c);
}

//-----------------------------------------------------------------------------
//      BT.2100 PQ OETFです.
//-----------------------------------------------------------------------------
float3 BT2100PQ_OETF(float3 color)
{
    float m1 = 0.1593017578125f;
    float m2 = 78.84375f;
    float c1 = 0.8359375f;
    float c2 = 18.8515625f;
    float c3 = 18.6875f;
    float3 Ym1 = Pow(abs(color), m1);
    return Pow((c1 + c2 * Ym1) / (1 + c3 * Ym1), m2);
}

//-----------------------------------------------------------------------------
//      BT.2100 PQ EOTFです.
//-----------------------------------------------------------------------------
float3 BT2100PQ_EOTF(float3 color)
{
    float m1 = 0.1593017578125f;
    float m2 = 78.84375f;
    float c1 = 0.8359375f;
    float c2 = 18.8515625f;
    float c3 = 18.6875f;
    float3 Ed = Pow(color, 1.0f / m2);
    return Pow(max(Ed - c1.xxx, 0.0f) / (c2 - c3 * Ed), 1.0f / m1);
}

//-----------------------------------------------------------------------------
//      BT.2100 PQ OOTFです.
//-----------------------------------------------------------------------------
float3 BT2100PQ_OOTF(float3 color)
{
    float3 Ed;
    Ed.x = (color.x <= 0.0003024f) ? 267.84 * color.x : 1.099f * Pow(59.5208f * color.x, 0.45f);
    Ed.y = (color.y <= 0.0003024f) ? 267.84 * color.y : 1.099f * Pow(59.5208f * color.y, 0.45f);
    Ed.z = (color.z <= 0.0003024f) ? 267.84 * color.z : 1.099f * Pow(59.5208f * color.z, 0.45f);

    return 100.0f * Pow(Ed, 2.4f);
}

//-----------------------------------------------------------------------------
//      BT.2100 HLG OETFです.
//-----------------------------------------------------------------------------
float3 BT2100HLG_OETF(float3 color)
{
    float3 result;

    float range = 1.0f / 12.0f;
    float a = 0.17883277f;
    float b = 0.28466892;
    float c = 0.55991073;

    result.x = (color.x <= range) ? sqrt(3.0f * color.x) : a * log(12.0f * color.x - b) + c;
    result.y = (color.y <= range) ? sqrt(3.0f * color.y) : a * log(12.0f * color.y - b) + c;
    result.z = (color.z <= range) ? sqrt(3.0f * color.z) : a * log(12.0f * color.z - b) + c;

    return result;
}

//-----------------------------------------------------------------------------
//      BT.2100 HTL EOTFです.
//-----------------------------------------------------------------------------
float3 BT2100HLG_EOTF(float3 color)
{
    float3 result;

    float a = 0.17883277f;
    float b = 0.28466892;
    float c = 0.55991073;
    result.x = (color.x <= 0.5f) ? color.x * color.x / 3.0f : (exp((color.x - c) / a) + b) / 12.0f;
    result.y = (color.y <= 0.5f) ? color.y * color.y / 3.0f : (exp((color.y - c) / a) + b) / 12.0f;
    result.z = (color.z <= 0.5f) ? color.z * color.z / 3.0f : (exp((color.z - c) / a) + b) / 12.0f;

    return result;
}

//-----------------------------------------------------------------------------
//      ITU-R BT.709からAdobeRGBへの変換.
//-----------------------------------------------------------------------------
float3 BT709_To_AdobeRGB(float3 color)
{
    const float3x3 conversion = 
    {
        0.715126f, 0.284874f, -0.000000f,
        0.000000f, 1.000000f, 0.000000f,
        0.000000f, 0.041162f, 0.958838f
    };
    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      ITU-R BT.709からDCI-P3への変換.
//-----------------------------------------------------------------------------
float3 BT709_To_DCI_P3(float3 color)
{
    const float3x3 conversion =
    {
        0.898952f, 0.194049f, 0.000000f,
        0.031821f, 0.926804f, 0.000000f,
        0.019654f, 0.083296f, 1.047586f
    };
    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      ITU-R BT.709からITU-R BT.2020への変換.
//-----------------------------------------------------------------------------
float3 BT709_To_BT2020(float3 color)
{
    const float3x3 conversion =
    {
          0.627404f, 0.329283f, 0.043313f,
          0.069097f, 0.919540f, 0.011362f,
          0.016391f, 0.088013f, 0.895595f
     };
     return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      ITU-R BT.709からCIE 1931 XYZ表色系への変換.
//-----------------------------------------------------------------------------
float3 BT709_To_XYZ(float3 color)
{
    const float3x3 conversion = 
    {
        0.412391f, 0.357584f, 0.180481f,
        0.212639f, 0.715169f, 0.072192f,
        0.019331f, 0.119195f, 0.950532f
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      ITU-R BT.20202からCIE 1931 XYZ表色系への変換.
//-----------------------------------------------------------------------------
float3 BT2020_To_XYZ(float3 color)
{
    const float3x3 conversion = 
    {
        0.636958f, 0.144617f, 0.168881f,
        0.262700f, 0.677998f, 0.059302f,
        0.000000f, 0.028073f, 1.060985f
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      DCI-P3からCIE 1931 XYZ表色系への変換.
//-----------------------------------------------------------------------------
float3 DCI_P3_To_XYZ(float3 color)
{
    const float3x3 conversion = 
    {
        0.445170f, 0.277134f, 0.172283f,
        0.209492f, 0.721595f, 0.068913f,
        0.000000f, 0.047061f, 0.907355f
    };

    return mul(conversion, color);    
}

//-----------------------------------------------------------------------------
//      AbodeRGBからCIE 1931 XYZ表色系への変換.
//-----------------------------------------------------------------------------
float3 AdobeRGB_To_XYZ(float3 color)
{
    const float3x3 conversion = 
    {
        0.576669f, 0.185558f, 0.188229f,
        0.297345f, 0.627363f, 0.075291f,
        0.027031f, 0.070689f, 0.991337f
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      ACES AP0からCIE 1931 XYZ表色系への変換.
//-----------------------------------------------------------------------------
float3 AP0_To_XYZ(float3 color)
{
    const float3x3 conversion = 
    {
        0.9525523959, 0.0000000000, 0.0000936786,
        0.3439664498, 0.7281660966, -0.0721325464,
        0.0000000000, 0.0000000000, 1.0088251844
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      ACES AP1からCIE 1931 XYZ表色系への変換.
//-----------------------------------------------------------------------------
float3 AP1_To_XYZ(float3 color)
{
    const float3x3 conversion = 
    {
        0.6624541811, 0.1340042065, 0.1561876870,
        0.2722287168, 0.6740817658, 0.0536895174,
       -0.0055746495, 0.0040607335, 1.0103391003
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      CIE xyY表色系からCIE 1931 XYZ表色系への変換.
//-----------------------------------------------------------------------------
float3 xyY_To_XYZ(float3 color)
{
    float3 xyY;
    float div = color.x + color.y + color.z;
    div = max(div, 1e-10);
    xyY.x = color.x / div;
    xyY.y = color.y / div;
    xyY.z = color.y;
    return xyY;
}

//-----------------------------------------------------------------------------
//      CIE 1931 XYZ表色系からITU-R BT.709への変換.
//-----------------------------------------------------------------------------
float3 XYZ_To_BT709(float3 color)
{
    const float3x3 conversion = 
    {
        3.240970f, -1.537383f, -0.498611f,
        -0.969244f, 1.875968f,  0.041555f,
        0.055630f, -0.203977f,  1.056972f
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      CIE 1931 XYZ表色系からITU-R BT.2020への変換.
//-----------------------------------------------------------------------------
float3 XYZ_To_BT2020(float3 color)
{
    const float3x3 conversion = 
    {
         1.716651f, -0.355671f, -0.253366f,
        -0.666684f,  1.616481f,  0.015769f,
         0.017640f, -0.042771f,  0.942103f
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      CIE 1931 XYZ表色系からDCI-P3への変換.
//-----------------------------------------------------------------------------
float3 XYZ_To_DCI_P3(float3 color)
{
    const float3x3 conversion = 
    {
         2.725394f, -1.018003f, -0.440163f,
        -0.795168f,  1.689732f,  0.022647f,
         0.041242f, -0.087639f,  1.100930f
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      CIE 1931 XYZ表色系からAdobeRGBへの変換.
//-----------------------------------------------------------------------------
float3 XYZ_To_AdobeRGB(float3 color)
{
    const float3x3 conversion = 
    {
         2.041588f, -0.565007f, -0.344731f,
        -0.969244f,  1.875968f,  0.041555f,
         0.013444f, -0.118362f,  1.015175f
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      CIE 1931 XYZ表色系からACES AP0への変換.
//-----------------------------------------------------------------------------
float3 XYZ_To_AP0(float3 color)
{
    const float3x3 conversion = 
    {
         1.0498110175, 0.0000000000, -0.0000974845,
        -0.4959030231, 1.3733130458,  0.0982400361,
         0.0000000000, 0.0000000000,  0.9912520182
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      CIE 1931 XYZ表色系からACES AP1への変換.
//-----------------------------------------------------------------------------
float3 XYZ_To_AP1(float3 color)
{
    const float3x3 conversion = 
    {
         1.6410233797, -0.3248032942, -0.2364246952,
        -0.6636628587,  1.6153315917,  0.0167563477,
         0.0117218943, -0.0082844420,  0.9883948585
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      CIE 1931 XYZ表色系からCIE xyYへの変換.
//-----------------------------------------------------------------------------
float3 XYZ_To_xyY(float3 color)
{
    float3 XYZ;
    XYZ.x = color.x * color.z / max(color.y, 1e-10);
    XYZ.y = color.z;
    XYZ.z = (1.0f - color.x - color.y) * color.z / max(color.y, 1e-10);
    
    return XYZ;
}

//-----------------------------------------------------------------------------
//      ITU-R BT709からCIE xyYへの変換.
//-----------------------------------------------------------------------------
float3 BT709_To_xyY(float3 color)
{
    float3 XYZ = BT709_To_XYZ(color);
    return XYZ_To_xyY(XYZ);
}

//-----------------------------------------------------------------------------
//      ITU-R BT.2020からCIE xyY表色系に変換します.
//-----------------------------------------------------------------------------
float3 BT2020_To_xyY(float3 color)
{
    float3 XYZ = BT2020_To_XYZ(color);
    return XYZ_To_xyY(XYZ);
}

//-----------------------------------------------------------------------------
//      CIE xyY表色系からITU-R BT.709への変換.
//-----------------------------------------------------------------------------
float3 xyY_To_BT709(float3 color)
{
    float3 XYZ = xyY_To_XYZ(color);
    return XYZ_To_BT709(XYZ);
};

//-----------------------------------------------------------------------------
//       CIE xyY表色系からAdobeRGBへの変換.
//-----------------------------------------------------------------------------
float3 xyY_To_AdobeRGB(float3 color)
{
    float3 XYZ = xyY_To_XYZ(color);
    return XYZ_To_AdobeRGB(XYZ);
}

//-----------------------------------------------------------------------------
//       CIE xyY表色系からDCI-P3への変換.
//-----------------------------------------------------------------------------
float3 xyY_To_DCI_P3(float3 color)
{
    float3 XYZ = xyY_To_XYZ(color);
    return XYZ_To_DCI_P3(XYZ);
}

//-----------------------------------------------------------------------------
//      CIE xyY表色系からITU-R BT.2020に変換します.
//-----------------------------------------------------------------------------
float3 xyY_To_BT2020(float3 color)
{
    float3 XYZ = xyY_To_XYZ(color);
    return XYZ_To_BT2020(XYZ);
}

//-----------------------------------------------------------------------------
//      ACES AP0 から ACES AP1への変換です.
//-----------------------------------------------------------------------------
float3 AP0_To_AP1(float3 color)
{
    const float3x3 conversion = 
    {
         1.4514393161, -0.2365107469, -0.2149285693,
        -0.0765537734,  1.1762296998, -0.0996759264,
         0.0083161484, -0.0060324498,  0.9977163014
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      ACES AP1からACES AP0への変換です.
//-----------------------------------------------------------------------------
float3 AP1_To_AP0(float3 color)
{
    const float3x3 conversion =
    {
         0.6954522414, 0.1406786965, 0.1638690622,
         0.0447945634, 0.8596711185, 0.0955343182,
        -0.0055258826, 0.0040252103, 1.0015006723
    };

    return mul(conversion, color);
}

//-----------------------------------------------------------------------------
//      ディザ処理.
//-----------------------------------------------------------------------------
void Dithering(float2 sv_position, float alpha)
{
    uint2 screenPos = (uint2)fmod(sv_position, 4.0f);
    if (alpha < F_DITHER_LIST[screenPos.x][screenPos.y])
    { discard; }
}

//-----------------------------------------------------------------------------
//      単なる視差マッピング.
//-----------------------------------------------------------------------------
float2 ParallaxMapping
(
    Texture2D       heightMap,      // 高さマップ.
    SamplerState    heightSmp,      // サンプラー.
    float2          texcoord,       // テクスチャ座標.
    float3          V,              // 視線ベクトル.
    float           heightScale     // 高さスケール.
)
{
    float  h = heightMap.Sample(heightSmp, texcoord).r;
    float2 p = (V.xy / V.z) * (h * heightScale);
    return texcoord - p;
}

//-----------------------------------------------------------------------------
//      視差遮断マッピング.
//-----------------------------------------------------------------------------
float2 ParallxOcclusionMapping
(
    Texture2D           heightMap,      // 高さマップ.
    SamplerState        heightSmp,      // 高さマップ用サンプラー.
    Texture2D<float>    depthMap,       // 深度マップ.
    SamplerState        depthSmp,       // 深度マップ用サンプラー.
    float2              texcoord,       // テクスチャ座標.
    float3              V,              // 視線ベクトル.
    float               heightScale,    // 高さスケール.
    const float         layerCount      // レイヤー数.
)
{
    float layerDepth     = 1.0f / layerCount; 
    float currLayerDepth = 0.0f;

    float2 p = V.xy * heightScale;
    float2 delta = p / layerCount;

    float2 currUV = texcoord;
    float currDepth = depthMap.Sample(depthSmp, currUV);

    [loop]
    while(currLayerDepth < currDepth)
    {
        currUV -= delta;
        currDepth = depthMap.Sample(depthSmp, currUV);
        currLayerDepth += layerDepth;
    }

    float2 prevUV = currUV + delta;
    float afterDepth = currDepth - currLayerDepth;
    float beforeDepth = depthMap.Sample(depthSmp, prevUV) - currLayerDepth + layerDepth;

    float weight = afterDepth / (afterDepth - beforeDepth);
    return lerp(currUV, prevUV, weight);
}

//-----------------------------------------------------------------------------
//      Ray vs Sphereの交差判定を行います.
//-----------------------------------------------------------------------------
bool RaySphereHit(float3 rayOrigin, float3 rayDir, float3 sphereCenter, float sphereRadius)
{
    float3 closestPointOnRay = max(0, dot(sphereCenter - rayOrigin, rayDir)) * rayDir;
    float3 centerToRay = rayOrigin + closestPointOnRay - sphereCenter;
    return dot(centerToRay, centerToRay) <= Sq(sphereRadius);
}

//-----------------------------------------------------------------------------
//      グロシネスに変換します.
//-----------------------------------------------------------------------------
float RoughnessToGlossiness(float roughness)
{ return saturate(1.0f - roughness); }

//-----------------------------------------------------------------------------
//      ラフネスに変換します.
//-----------------------------------------------------------------------------
float GlossinessToRoughness(float glossiness)
{ return saturate(1.0f - glossiness); }

//-----------------------------------------------------------------------------
//      PBR RoughnessからTradiational Specular Powerに変換します.
//-----------------------------------------------------------------------------
float GlossinessToSpecularPower(float glossiness)
{
    // Sebastien Lagarade, "Adopting a physically based shading model", 
    // https://seblagarde.wordpress.com/2011/08/17/hello-world/
    // ※有効範囲は[2, 2048]まで.
    return exp2(10.0f * glossiness + 1.0f);
}

//-----------------------------------------------------------------------------
//      Traditional Specular Power から PBR Glossinessに変換します.
//-----------------------------------------------------------------------------
float SpecularPowerToGlossiness(float specularPower)
{ return log2(specularPower) * 0.01f - 1.0f; }

//-----------------------------------------------------------------------------
//      Traditional Specular Power から　PBR Roughnessに変換します.
//-----------------------------------------------------------------------------
float SpecularPowerToRoughness(float specularPower)
{ return SpecularPowerToRoughness(SpecularPowerToGlossiness(specularPower)); }

//-----------------------------------------------------------------------------
//      Geomerics方式で球面調和関数を評価します.
//-----------------------------------------------------------------------------
float IrradianceSH_NonlinearL1(float3 normal, float4 coeff)
{
    // William Joseph, "球面調和関数データからの拡散反射光の再現", CEDEC 2015,
    // https://cedil.cesa.or.jp/cedil_sessions/view/1329
    float  L0 = coeff.x;
    float3 L1 = coeff.yzw;
    float  modL1 = length(L1);
    if (modL1 == 0.0f)
    { return 0.0f; }

    float q = saturate(0.5f + 0.5f * dot(normal, normalize(L1)));
    float r = modL1 / L0;
    float p = 1.0f + 2.0f * r;
    float a = (1.0f - r) / (1.0f + r);

    return L0 * lerp((1.0f + p) * Pow(q, p), 1.0f, a);
}

//-----------------------------------------------------------------------------
//      X軸を取得します.
//-----------------------------------------------------------------------------
float3 GetAxisX(float4x4 view)
{ return normalize(view._11_12_13); }

//-----------------------------------------------------------------------------
//      Y軸を取得します.
//-----------------------------------------------------------------------------
float3 GetAxisY(float4x4 view)
{ return normalize(view._21_22_23); }

//-----------------------------------------------------------------------------
//      Z軸を取得します.
//-----------------------------------------------------------------------------
float3 GetAxisZ(float4x4 view)
{ return normalize(view._31_32_33); }

//-----------------------------------------------------------------------------
//      平行移動成分を取得します.
//-----------------------------------------------------------------------------
float3 GetTranslate(float4x4 view)
{ return view._41_42_43; }

//-----------------------------------------------------------------------------
//      X軸周りの回転行列を生成します.
//-----------------------------------------------------------------------------
float4x4 CreateRotationX(float radian)
{
    float sinRad, cosRad;
    sincos(radian, sinRad, cosRad);
    return float4x4(
        1.0f,     0.0f,     0.0f,   0.0f,
        0.0f,    cosRad,  sinRad,   0.0f,
        0.0f,   -sinRad,  cosRad,   0.0f,
        0.0f,      0.0f,    0.0f,   1.0f);
}

//-----------------------------------------------------------------------------
//      Y軸周りの回転行列を生成します.
//-----------------------------------------------------------------------------
float4x4 CreateRotationY(float radian)
{
    float sinRad, cosRad;
    sincos(radian, sinRad, cosRad);
    return float4x4(
        cosRad,     0.0f,   -sinRad,    0.0f,
          0.0f,     1.0f,      0.0f,    0.0f,
        sinRad,     0.0f,    cosRad,    0.0f,
          0.0f,     0.0f,      0.0f,    1.0f);
}

//-----------------------------------------------------------------------------
//      Z軸周りの回転行列を生成します.
//-----------------------------------------------------------------------------
float4x4 CreateRotationZ(float radian)
{
    float sinRad, cosRad;
    sincos(radian, sinRad, cosRad);
    return float4x4(
      cosRad,   sinRad,     0.0f,   0.0f,
     -sinRad,   cosRad,     0.0f,   0.0f,
        0.0f,     0.0f,     1.0f,   0.0f,
        0.0f,     0.0f,     0.0f,   1.0f);
}

//-----------------------------------------------------------------------------
//      リムライトを適用します.
//-----------------------------------------------------------------------------
float SmashBrosRim(float3 N, float3 cameraX, float3 cameraY, float3 cameraZ, float2 angle, float rimPower)
{
    // 岩永 欣仁, 鈴木 雅幸, 『大乱闘スマッシュブラザーズ SPECIAL』～お借りしたIPをできるだけ綺麗に描くために,
    // CEDEC 2019.

    // 普通のリム計算.
    float3 V = cameraZ;
    float NoV = saturate(dot(N, V));
    float rim = Pow(saturate(1.0f - NoV), rimPower);

    // マスク用ライトベクトル.
    float3 L = cameraZ * cos(angle.x) * cos(angle.y)
             + cameraY * sin(angle.y)
             + cameraX * sin(angle.x) * cos(angle.y);

    // Half-Lambertによるグラデーションマスク.
    float mask = Pow2(max(dot(L, N), 0) * 0.5f + 0.5f);

    return rim * mask;
}

#endif//MATH_HLSLI
