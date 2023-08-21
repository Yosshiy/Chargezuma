using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;

public class Setting : MonoBehaviour
{
    [SerializeField] BGMSetting BGM;
    [SerializeField] UI_Sound Sound;

    private void Awake()
    {
        Sound.Initialize();
        SetUp();
    }

    private void SetUp()
    {
        Sound.OnBGM
             .DistinctUntilChanged()
             .Subscribe(x => BGM.BGMVoulume(x));
    }
}
