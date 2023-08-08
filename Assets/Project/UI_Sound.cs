using Cysharp.Threading.Tasks;
using System;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;
using UnityEngine.UI;

public class UI_Sound : MonoBehaviour
{
    [SerializeField] Slider BGMSlider;
    [SerializeField] Slider SESlider;

    public IObservable<float> OnBGM;
    public IObservable<float> OnSE;

    public void Initialize()
    {
        OnBGM = BGMSlider.ObserveEveryValueChanged(x => x.value);
        OnSE = SESlider.ObserveEveryValueChanged(x => x.value);
    }
}
