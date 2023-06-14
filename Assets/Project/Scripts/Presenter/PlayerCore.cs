using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;

[RequireComponent(typeof(PlayerMove))]
public class PlayerCore : MonoBehaviour
{
    PlayerMove Move;
    IInputAdaptor InputAdaptor = default;
    PlayerParametor para;

    void Start()
    {
        Move = GetComponent<PlayerMove>();
        InputAdaptor = new InputAdaptor();
        para = new PlayerParametor();
        InputAdaptor.Initialize();

        OnInitialize();
    }

    private void OnInitialize()
    {
        InputAdaptor.GetDirection
                    .Subscribe(x => Move.Move(x * para.Speed));
    }
}
