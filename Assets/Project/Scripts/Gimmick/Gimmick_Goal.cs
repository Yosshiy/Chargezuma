using DG.Tweening;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Gimmick_Goal : MonoBehaviour
{
    [SerializeField] Image Span;
    [SerializeField] TextMeshProUGUI Text;
    [SerializeField] TextMeshProUGUI NextText;
    [SerializeField] TextMeshProUGUI retrayText;



    void OnCollisionEnter(Collision other)
    {
        other.transform.GetComponent<Rigidbody>().isKinematic = true;


        DOTween.Sequence()
               .Append(Span.DOFade(0.8f, 0.5f))
               .Append(Text.transform.DOScaleX(1, 0.3f))
               .Append(DOTween.To(() => Text.characterSpacing, (x) => Text.characterSpacing = x, 40, 2))
               .Append(NextText.DOFade(1, 0.5f))
               .Append(retrayText.DOFade(1, 0.5f));

    }
}
