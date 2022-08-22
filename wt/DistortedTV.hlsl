// original: https://www.shadertoy.com/view/ldXGW4 by https://www.shadertoy.com/user/ehj1

Texture2D shaderTexture;
SamplerState samplerState;

cbuffer PixelShaderSettings
{
  float Time;
  float Scale;
  float2 Resolution;
  float4 Background;
};

float3 mod289(float3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float2 mod289(float2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

float3 permute(float3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(float2 v) {
  const float4 C = float4(0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439);
  float2 i  = floor(v + dot(v, C.yy) );
  float2 x0 = v -   i + dot(i, C.xx);
  float2 i1;
  i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
  float4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod289(i);
  float3 p = permute( permute( i.y + float3(0.0, i1.y, 1.0 )) + i.x + float3(0.0, i1.x, 1.0 ));
  float3 m = max(0.5 - float3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m;
  m = m*m;
  float3 x = 2.0 * frac(p * C.www) - 1.0;
  float3 h = abs(x) - 0.5;
  float3 ox = floor(x + 0.5);
  float3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  float3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float staticV(float2 uv) {
  float staticHeight = snoise(float2(9.0,Time*1.2+3.0))*0.3+5.0;
  float staticAmount = snoise(float2(1.0,Time*1.2-6.0))*0.1+0.3;
  float staticStrength = snoise(float2(-9.75,Time*0.6-3.0))*2.0+2.0;
  return (1.0-step(snoise(float2(5.0*pow(Time,2.0)+pow(uv.x*7.0,1.2),pow((fmod(Time,100.0)+100.0)*uv.y*0.3+3.0,staticHeight))),staticAmount))*staticStrength;
}

float4 main(float4 pos : SV_POSITION, float2 uv : TEXCOORD) : SV_TARGET
{
  // params
  float vertJerkOpt = .5;
  float vertMovementOpt = .2;
  float bottomStaticOpt = 1.0;
  float scalinesOpt = 1.0;
  float rgbOffsetOpt = .2;
  float horzFuzzOpt = .5;

  // process
  float fuzzOffset      = snoise(float2(Time*15.0, uv.y*80.0))*0.003;
  float largeFuzzOffset = snoise(float2(Time*1.0,  uv.y*25.0))*0.004;
  float vertMovementOn  = (1.0-step(snoise(float2(Time*0.2,8.0)),0.4))*vertMovementOpt;
  float vertJerk        = (1.0-step(snoise(float2(Time*1.5,5.0)),0.6))*vertJerkOpt;
  float vertJerk2       = (1.0-step(snoise(float2(Time*5.5,5.0)),0.2))*vertJerkOpt;
  float xOffset         = (fuzzOffset + largeFuzzOffset) * horzFuzzOpt;
  float yOffset         = abs(sin(Time)*4.0)*vertMovementOn+vertJerk*vertJerk2*0.3;
  float staticVal = 0.0;
  for (float yy = -1.0; yy <= 1.0; yy += 1.0) {
    float maxDist = 5.0/200.0;
    float dist = yy/200.0;
    staticVal += staticV(float2(uv.x,uv.y+dist))*(maxDist-abs(dist))*1.5;
  }
  staticVal   *= bottomStaticOpt;
  float y     = fmod(uv.y+yOffset,1.0);
  float red   = shaderTexture.Sample(samplerState, float2(uv.x + xOffset -0.01*rgbOffsetOpt, y)).r+staticVal;
  float green = shaderTexture.Sample(samplerState, float2(uv.x + xOffset                   , y)).g+staticVal;
  float blue  = shaderTexture.Sample(samplerState, float2(uv.x + xOffset +0.01*rgbOffsetOpt, y)).b+staticVal;
  float3 src  = float3(red, green, blue);
  float scanline = sin(uv.y*800.0)*0.04*scalinesOpt;
  src -= scanline;
  return float4(src, 1.0);
}
