using DG.Tweening;
using UnityEngine;

/// <summary>
/// プレイヤーの当たり判定
/// </summary>
public class PlayerCollider : PlayerCore 
{
    /// <summary>
    /// 初期化
    /// </summary>
    protected override void OnInitialize()
    {
        //何もすることがないので素通し
    }

    /// <summary>
    /// 加速処理
    /// </summary>
    public void OnAcceleration()
    {
        DOTween.Sequence()
               .Append(Camera.main.DOFieldOfView(70, 1f))
               .Append(Camera.main.DOFieldOfView(60, 3f));
        PlayerData.OnAccelerationSpeed += 0.75f;
        PlayerData.AccelerationChanged();
    }

    /// <summary>
    /// ジャンプ処理
    /// </summary>
    public void OnJump()
    {
        GetComponent<PlayerMove>().Jump(PlayerData.OnJumpPower * 1.3f);
        PlayerData.OnAccelerationSpeed += 0.5f;
        PlayerData.AccelerationChanged();
    }
}
