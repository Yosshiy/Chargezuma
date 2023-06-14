using Cysharp.Threading.Tasks;
using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

public class Fade : MonoBehaviour
{
    [SerializeField] Image FadePanel;
    [SerializeField] GameObject Pivot;

    public async UniTask FadeIn()
    {
        await FadePanel.DOFade(1, 3)
                       .SetEase(Ease.InOutCubic);

        await UniTask.Delay(1000);
                       
    }

    public void FadeOut()
    {
        FadePanel.DOFade(0,1);
    }
}
