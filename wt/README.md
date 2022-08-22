# Windows Terminal あれこれ

## hlsl

* Windows Terminalのsetting.jsonの、各種Profile-list中の適用したい環境設定の中に、hlslファイルへのパスを追加。

```
  "experimental.pixelShaderPath": "C:\\path\\to\\DistortedTV.hlsl",
```

### サンプル

* [DistortedTV](DistortedTV.hlsl): 古いアナログテレビ風。実用にはパラメータ値を下げた方がよいかも。
  * <https://www.shadertoy.com/view/ldXGW4>をHLSLに移植したものです。

![DistortedTV.gif](DistortedTV.gif)
