using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationDisolve : AAnimation
{
    [SerializeField] List<Renderer> DesolveObj;


    public override void PlayAnimation()
    {
        foreach(var obj in DesolveObj)
        {
            DOTween.Sequence(obj)
                   .Append(obj.material.DOFloat(1, "_Count", 1.5f))
                   .SetEase(Ease.InOutCubic)
                   .AppendInterval(1)
                   .AppendCallback(() => obj.gameObject.SetActive(false));

        }

    }



}
