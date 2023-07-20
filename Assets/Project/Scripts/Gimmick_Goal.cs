using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Gimmick_Goal : MonoBehaviour
{
    [SerializeField] Image Span;
    [SerializeField] TextMeshProUGUI Text;

    void OnCollisionEnter(Collision other)
    {
        other.transform.GetComponent<Rigidbody>().isKinematic = true;


        DOTween.Sequence()
               .Append(Span.DOFade(0.8f, 0.5f))
               .Append(Text.transform.DOScaleX(1, 0.3f))
               .AppendCallback(() =>
               {
                   DOTween.To(() => Text.characterSpacing, (x) => Text.characterSpacing = x, 40, 2);

               });

    }
}
