using System;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;

/// <summary>
/// ステージ遷移用子スクリプト
/// ステージ遷移用オブジェクトにこのスクリプトを張り付けして使用
/// </summary>
public class StageChangeChild : MonoBehaviour
{
    //公開用変数
    public IObservable<bool> OnStay => StayProperty;
    public string OnSceneName => NextSceneName;
    public bool OnStaysum => Staysum;
    bool Staysum;

    //private変数
    ReactiveProperty<bool> StayProperty = new ReactiveProperty<bool>();
    //次に遷移させたいシーン名
    //※少し煩雑になりそうなのでシーン操作系は後でまとめておくこと
    [SerializeField] string NextSceneName;

    /// <summary>
    /// 範囲内に入ったときフラグを立てる
    /// </summary>
    private void OnTriggerEnter(Collider other)
    {
        Staysum = true;
    }

    /// <summary>
    /// 範囲外に出たときフラグを下す
    /// </summary>
    private void OnTriggerExit(Collider other)
    {
        Staysum = false;
    }
}
