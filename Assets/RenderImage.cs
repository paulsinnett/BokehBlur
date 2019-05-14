using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderImage : MonoBehaviour
{
	public Texture source;
	public Material verticalPass;
	public Material horizontalPass;
	public Material combine;

	Vector2 [] verticalOffsets = new Vector2 [] 
	{
		new Vector2(0.0f, -1.0f),
		new Vector2(0.0f,  0.0f),
		new Vector2(0.0f,  1.0f),
	};

	Vector2 [] horizontalOffsets = new Vector2 [] 
	{
		new Vector2(-1.0f, 0.0f),
		new Vector2( 0.0f, 0.0f),
		new Vector2( 1.0f, 0.0f),
	};

	void OnRenderImage(RenderTexture dummy, RenderTexture destination)
	{
		RenderTextureDescriptor format = 
			new RenderTextureDescriptor(3840, 2160);
		RenderTexture stretch = RenderTexture.GetTemporary(format);
		Graphics.Blit(source, stretch);
		RenderTexture vertical = RenderTexture.GetTemporary(format);
		Graphics.BlitMultiTap(stretch, vertical, verticalPass, verticalOffsets);
		RenderTexture.ReleaseTemporary(stretch);
		RenderTexture horizontal = RenderTexture.GetTemporary(format);
		Graphics.BlitMultiTap(vertical, horizontal, horizontalPass, horizontalOffsets);
		RenderTexture.ReleaseTemporary(vertical);
		combine.SetTexture("_BlurTex", horizontal);
		Graphics.Blit(source, destination, combine);
		RenderTexture.ReleaseTemporary(horizontal);
	}
}
