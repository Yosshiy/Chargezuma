using System;
using UniRx;
using UnityEngine;

/// <summary>
/// テスト用入力
/// </summary>
public class TestInputAdaptor : IInputAdaptor,IDisposable
{
    //Dispose管理用
    private CompositeDisposable Disposable = default;
    //ジャンプ入力
    private ReactiveProperty<bool> Jump = new BoolReactiveProperty();
    //移動ベクトル
    private ReactiveProperty<Vector3> MoveDirection = new ReactiveProperty<Vector3>();

    ///////--公開用--///////
    public IReadOnlyReactiveProperty<Vector3> OnMoveDirection { get { return MoveDirection; } }
    public IReadOnlyReactiveProperty<bool> OnJump { get { return Jump; } }

    /// <summary>
    /// 初期化設定
    /// </summary>
    public TestInputAdaptor()
    {
        Disposable = new CompositeDisposable();

        Observable.EveryUpdate()
            .Select(_ => Input.GetKey(KeyCode.Space))
            .DistinctUntilChanged()
            .Subscribe(x => Jump.Value = x)
            .AddTo(Disposable);

        Observable.EveryUpdate()
            .Select(_ => new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")))
            .Subscribe(x => MoveDirection.SetValueAndForceNotify(x))
            .AddTo(Disposable);
    }

    /// <summary>
    /// Dispose : 解放用関数
    /// </summary>
    public void Dispose()
    {
        Disposable.Dispose();
    }
}
