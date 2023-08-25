using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Chargezuma.Gimmick
{
    /// <summary>
    /// プレイヤーがゲームオーバーになった時の処理
    /// </summary>
    public class Gimmick_Death : AGimmick
    {
        //画面を少し暗くさせる用のImage
        [SerializeField] Image Span;
        //ゲームオーバーテキスト
        [SerializeField] TextMeshProUGUI Text;
        //前シーンにもどるテキスト
        [SerializeField] TextMeshProUGUI NextText;
        //当ステージの再プレイテキスト
        [SerializeField] TextMeshProUGUI retrayText;

        protected override void OnTriggerEnter(Collider other)
        {
            other.GetComponent<Rigidbody>().isKinematic = true;
        }

        protected override void PlayAction()
        {
            DOTween.Sequence()
                   .Append(Span.DOFade(0.8f, 0.5f))
                   .Append(Text.transform.DOScaleX(1, 0.3f))
                   .Append(DOTween.To(() => Text.characterSpacing, (x) => Text.characterSpacing = x, 40, 2))
                   .Append(NextText.DOFade(1, 0.5f))
                   .Append(retrayText.DOFade(1, 0.5f))
                   .SetLink(this.gameObject);
        }
    }
}
