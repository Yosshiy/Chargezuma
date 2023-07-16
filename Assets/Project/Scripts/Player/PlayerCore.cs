using Cysharp.Threading.Tasks.Triggers;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Zenject;

public abstract class PlayerCore : MonoBehaviour
{
    IInputAdaptor Input = default;
    [Inject]
    PlayerData Data;

    protected IInputAdaptor PlayerInput { get {  return Input; } }
    protected PlayerData PlayerData { get {  return Data; } }

    private void Start()
    {
        Input = new TestInputAdaptor();

        OnInitialize();
    }

    //初期化処理
    protected abstract void OnInitialize();

}
