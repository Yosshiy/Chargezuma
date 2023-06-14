using System;
using System.Collections;
using System.Collections.Generic;
using UniRx;
using UnityEngine;

public class InputAdaptor : IInputAdaptor,IDisposable
{
    CompositeDisposable Disposable = new CompositeDisposable();

    ReactiveProperty<Vector3> Direction = new ReactiveProperty<Vector3>();
    ReactiveProperty<bool> Action = new ReactiveProperty<bool>();

    public IReactiveProperty<Vector3> GetDirection => Direction;
    public IReactiveProperty<bool> GetAction => Action;

    public void Initialize()
    {
        Observable.EveryUpdate()
                  .Select(x => new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")))
                  .Subscribe(x => Direction.SetValueAndForceNotify(x))
                  .AddTo(Disposable);

        Observable.EveryUpdate()
                  .Select(x => Input.GetKeyDown(KeyCode.Q))
                  .Subscribe(x => Action.Value = x)
                  .AddTo(Disposable);
    }

    void IDisposable.Dispose()
    {
        Disposable.Dispose();
    }
}
