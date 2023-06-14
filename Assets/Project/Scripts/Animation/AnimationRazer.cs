using DG.Tweening;
using JetBrains.Annotations;
using System;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;

public class AnimationRazer : AAnimation
{
    [SerializeField] List<GameObject> Lazer;
    Subject<float> A = new Subject<float>();
    public Subject<float> AA { get { return A; } }

    bool AnimationPlayed;
    

    private void Awake()
    {
       
    }

    public override void PlayAnimation()
    {
        float endValue = 0;

        if (AnimationPlayed)
        {
            endValue = 0.5f;
        }else
        
        if (!AnimationPlayed)
        {
            endValue = 0;
        }

        DOTween.Sequence()
            .AppendCallback(() =>
            {
                for (int i = 0; i < Lazer.Count; i++)
                {
                    Lazer[i].SetActive(true);
                }

            })
            .AppendCallback(() =>
            {
                for (int i = 0; i < Lazer.Count; i++)
                {
                    Lazer[i].transform.DOScaleX(endValue, 0.2f);
                    Lazer[i].transform.DOScaleZ(endValue, 0.2f);
                }
            })
            .AppendInterval(0.2f)
            .AppendCallback(() =>
            {
                for (int i = 0; i < Lazer.Count; i++)
                {
                    Lazer[i].SetActive(AnimationPlayed);
                }

                AnimationPlayed = !AnimationPlayed;
            });
    }
}
