using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Animationhummer : AAnimation
{
    [SerializeField] GameObject hummer;

    public override void PlayAnimation()
    {
        hummer.transform.DORotate(Vector3.zero,0.5f);
    }
}
