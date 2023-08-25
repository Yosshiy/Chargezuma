using Cysharp.Threading.Tasks;
using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

namespace Chargezuma.View.Output
{

    /// <summary>
    /// Scene遷移の際のアニメーションスクリプト
    /// </summary>
    public class SceneAnimation : MonoBehaviour, ISceneOutput
    {
        //アニメーション対象
        [SerializeField] Image FadePanel;

        /// <summary>
        /// フェードインアニメーション
        /// 合計アニメーション時間 : 1.5f
        /// </summary>
        async UniTask ISceneOutput.FadeIn()
        {
            await DOTween.Sequence()
                   .Append(FadePanel.material.DOFloat(0.5f, "_Fade", 0.3f).SetEase(Ease.OutBack))
                   .AppendInterval(0.2f)
                   .Append(FadePanel.material.DOFloat(1.5f, "_Fade", 0.5f).SetEase(Ease.OutCirc))
                   .Append(FadePanel.material.DOFloat(1.2f, "_Volt", 0.5f))
                   .SetLink(this.gameObject);
        }

        /// <summary>
        /// フェードアウトのアニメーション
        /// 合計アニメーション時間 : 1f + インターバル1秒
        /// </summary>
        async UniTask ISceneOutput.FadeOut()
        {
            await DOTween.Sequence()
                   .AppendInterval(1)
                   .Append(FadePanel.material.DOFloat(0f, "_Volt", 0.5f))
                   .Append(FadePanel.material.DOFloat(0f, "_Fade", 0.5f).SetEase(Ease.OutCirc))
                   .SetLink(this.gameObject);
        }
    }
}
