﻿Shader "Custom/TextureMixShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Color2 ("Color2", Color) = (1, 1, 1, 1)
		_SubTex("SubAlbedo (RGB)", 2D) = "white" {}
		_Fade("Fade", Range(0,1)) = 1
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_TexToGray("BW blend", Range(0,1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _SubTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SubTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		fixed4 _Color2;
		float _Fade;
		fixed _TexToGray;
		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		

		void surf (Input IN, inout SurfaceOutputStandard o) {

			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 c2 = tex2D (_SubTex, IN.uv_SubTex) * _Color2;
			fixed4 gray = (c.r + c.g + c.b)/3;
			fixed4 gray2 = (c2.r + c2.g + c2.b)/3;
			o.Albedo = (c.rgb*_Fade +  c2.rgb*(1-_Fade))*(1-_TexToGray) + (gray.rgb*_Fade + gray2.rgb*(1-_Fade))*(_TexToGray);
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}