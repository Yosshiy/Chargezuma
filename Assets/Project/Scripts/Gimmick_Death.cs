using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Gimmick_Death : MonoBehaviour
{
    [SerializeField] Image Span;
    [SerializeField] TextMeshProUGUI Text;
    [SerializeField] TextMeshProUGUI NextText;
    [SerializeField] TextMeshProUGUI retrayText;

    private void OnTriggerEnter(Collider other)
    {
        other.GetComponent<Rigidbody>().isKinematic  =true;


        DOTween.Sequence()
               .Append(Span.DOFade(0.8f, 0.5f))
               .Append(Text.transform.DOScaleX(1, 0.3f))
               .Append(DOTween.To(() => Text.characterSpacing, (x) => Text.characterSpacing = x, 40, 2))
               .Append(NextText.DOFade(1,0.5f))
               .Append(retrayText.DOFade(1,0.5f));

    }
}
