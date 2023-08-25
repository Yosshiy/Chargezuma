using DG.Tweening;
using UniRx;

/// <summary>
/// Playerのデータを扱うクラス
/// </summary>
public class PlayerData
{
    //ジャンプ力
    float JumpPower = 8;
    //移動速度
    float DefaultSpeed = 7;
    //加速度
    float Acceleration = 1;
    //加速上限値
    float MaxAcceleration = 3;
    ReactiveProperty<PlayerParam> ParamProperty;
    //加速度を初期値に戻すTween
    Tween AccelTo;

    public float OnJumpPower { get {  return JumpPower; }}
    public float OnAccelerationSpeed { get {  return Acceleration; } set {  Acceleration = value; } }
    public float OnDefaultSpeed { get { return DefaultSpeed; }}

    public void AccelerationChanged()
    {
        if(Acceleration > MaxAcceleration)
        {
            Acceleration = MaxAcceleration;
        }

        AccelTo.Kill();
        AccelTo = DOTween.To(() => Acceleration,(x) => Acceleration = x, 1, 3)
               .SetEase(Ease.Linear);
    }
}

public enum PlayerParam
{
    Death,
    Life
}