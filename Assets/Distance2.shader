﻿Shader "Custom/Distance2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv[3] : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv[3] : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv[0] = v.uv[0];
				o.uv[1] = v.uv[1];
				o.uv[2] = v.uv[2];
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = min(1.0, min(min(
					tex2D(_MainTex, i.uv[0]) + 0.25,
					tex2D(_MainTex, i.uv[1])),
					tex2D(_MainTex, i.uv[2]) + 0.25));
				return col;
			}
			ENDCG
		}
	}
}
