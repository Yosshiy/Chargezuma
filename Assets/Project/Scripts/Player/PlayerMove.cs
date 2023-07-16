using UniRx;
using UnityEngine;

/// <summary>
/// プレイヤーの動き
/// </summary>
[RequireComponent(typeof(Rigidbody))]
public class PlayerMove : PlayerCore
{
    ReactiveProperty<bool> LocalIsJump = new ReactiveProperty<bool>();
    ReactiveProperty<bool> LocalIsWalk = new ReactiveProperty<bool>();

    public IReadOnlyReactiveProperty<bool> IsJump => LocalIsJump;
    public IReadOnlyReactiveProperty<bool> IsWalk => LocalIsWalk;


    Rigidbody Rigid;

    /// <summary>
    /// 初期化
    /// </summary>
    protected override void OnInitialize()
    {
        Rigid = GetComponent<Rigidbody>();

        PlayerInput.OnJump
                   .Where(x => x == true)
                   .Subscribe(x => Jump(PlayerData.OnJumpPower));

        PlayerInput.OnMoveDirection
                   .Subscribe(x => OnMove(x));
    }

    /// <summary>
    /// 移動
    /// </summary>
    /// <param name="direction">移動方向へのベクトル/// </param>
    public void OnMove(Vector3 direction)
    {
        //斜め移動が早くならないように対策
        direction.Normalize();
        //スピードを計算
        direction *= PlayerData.OnDefaultSpeed;
        //加速度の計算
        direction *= PlayerData.OnAccelerationSpeed;
        //縦軸を現在の値に変更
        direction.y = Rigid.velocity.y;
        //　移動処理
        Rigid.velocity = direction;

    }

    /// <summary>
    /// ジャンプ
    /// </summary>
    /// <param name="jumpdirection">ジャンプ方向へのベクトル</param>
    public void Jump(float jump)
    {
        var jumpdirection = new Vector3(0,jump,0);
        Rigid.AddForce(jumpdirection, ForceMode.Impulse);
    }
}
