using Cysharp.Threading.Tasks.Triggers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Zenject;

/// <summary>
/// プレイヤーの基底クラス
/// </summary>
public abstract class PlayerCore : MonoBehaviour
{
    IInputAdaptor Input = default;
    [Inject]
    PlayerData Data;

    protected IInputAdaptor PlayerInput { get {  return Input; } }
    protected PlayerData PlayerData { get {  return Data; } }

    private void Start()
    {
        //インプット
        Input = new TestInputAdaptor();
        //初期化
        OnInitialize();
    }

    //初期化処理
    protected abstract void OnInitialize();

}
