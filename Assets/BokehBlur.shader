Shader "Custom/BokehBlur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlurTex ("Blur Texture", 2D) = "white" {}
		_Wipe ("Wipe", Range(0, 1)) = 0.5
		_Light ("Light", Range(0, 4)) = 1.0
		_Dark ("Dark", Range(0, 4)) = 4.0
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
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			uniform sampler2D _MainTex;
			uniform sampler2D _BlurTex;
			uniform float _Wipe;
			uniform float _Light;
			uniform float _Dark;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = lerp(
					tex2D(_MainTex, i.uv), 
					(1.0 - smoothstep(_Light, _Dark, tex2D(_BlurTex, i.uv) * 4.0)),
					step(_Wipe, i.uv.x));
				return col;
			}
			ENDCG
		}
	}
}
